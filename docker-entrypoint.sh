#!/bin/bash

service saslauthd start
/usr/local/libexec/slapd -d 1024
