#!/bin/sh

guix pull
guix package -i bats-core python-pycapnp px-accounts-service px-secret-service px-accounts-service-plugin-protocol-imap
