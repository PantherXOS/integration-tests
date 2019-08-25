#!/bin/sh

guix pull
guix package -i px-settings-service px-secret-service px-events-service px-accounts-service px-settings-service-plugin-accounts-service
