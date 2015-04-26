# Vagrant Dev Environment

It is my recent attempt to every project in a separate VM.
This repository contains basic directory structure and common
recipes to provision VMs.

## Preparation

1. Install ansible
2. Install vagrant
3. Install Virtual Box or VMWare Fusion
4. Clone this repo
5. Run `make local`. This will install required vagrant plugins, create CA certificate and initialize your secrets.yml vault
6. Run `open ssl/ca.crt` and trust the certificate
