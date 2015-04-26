mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))

DOMAIN ?= dev
OPENSSL_BIN ?= /usr/bin/openssl

local: ssl/ca.crt ssl/ca.key
	ansible-playbook ansible/local.yml
	make ansible/inventory/vagrant_ansible_inventory
	touch secrets.yml
	(test "$$(cat secrets.yml | head -n 1 | cut -f1 -d';')" = '$$ANSIBLE_VAULT') || (echo "Provide your secrets.yml encryption password" && ansible-vault encrypt secrets.yml)

ansible/inventory/vagrant_ansible_inventory: .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
	ln -sf ${current_dir}/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
		${current_dir}/ansible/inventory/vagrant_ansible_inventory

.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory: .vagrant/provisioners/ansible/inventory
	touch .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

.vagrant/provisioners/ansible/inventory:
	mkdir -p .vagrant/provisioners/ansible/inventory

ssl:
	mkdir ssl

%.key: ssl
	$(info ************ Generating $@ ************)
	${OPENSSL_BIN} genrsa -out $@ 2048

ssl/ca.crt: ssl/ca.key
	$(info ******** Generating CA certificate ********)
	${OPENSSL_BIN} req -new -x509 -extensions v3_ca -key ssl/ca.key -passin pass: \
		-out ssl/ca.crt -days 3650 -subj "/C=US/ST=WA/L=DC/O=IT/CN=${DOMAIN}"

%.csr: %.key
	${OPENSSL_BIN} req -new -extensions v3_ca -key $< -passin pass: \
		-out $@ -days 3650 -subj "/C=US/ST=WA/L=DC/O=IT/CN=${DOMAIN}"

demoCA:
	mkdir -p demoCA/newcerts
	touch demoCA/index.txt
	echo "1000" > demoCA/serial

%.crt: %.key %.csr demoCA
	echo "y\ny\n" | ${OPENSSL_BIN} ca -keyfile ssl/ca.key -cert ssl/ca.crt \
    -extensions usr_cert -notext -md sha256 -passin pass: \
    -in $*.csr -out $*.crt
	rm -fr demoCA
