#!/bin/sh

guix pull
guix package -i px-secret-service px-events-service px-accounts-service px-accounts-service-plugin-etherscan px-accounts-service-plugin-blockio px-settings-service px-settings-service-plugin-accounts
