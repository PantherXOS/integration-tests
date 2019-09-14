#!/bin/sh

guix pull
guix package -i bats-core python-pycapnp python-pynng px-accounts-service px-secret-service px-event-service px-accounts-service-plugin-blockio px-accounts-service-plugin-etherscan px-accounts-service-plugin-imap px-accounts-service-plugin-cryptocurrency
