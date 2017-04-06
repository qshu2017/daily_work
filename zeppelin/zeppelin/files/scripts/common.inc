#!/bin/bash

HOOK_USER=`whoami`
export WORKING_DIR=`eval echo ~$HOOK_USER`

export NOTEBOOK_PORT_LOCK_PATH=/tmp/notebooks

