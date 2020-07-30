#!/bin/sh

guix environment --ad-hoc coreutils -m manifest.scm -- sh run.sh ${@}
