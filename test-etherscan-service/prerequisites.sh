#!/bin/sh

guix pull
guix package -i python-pycapnp px-accounts-service px-secret-service px-events-service px-accounts-service-plugin-etherscan px-accounts-service-plugin-cryptocurrency
