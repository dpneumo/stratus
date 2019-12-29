#!/usr/bin/env bash

# Run unprivileged
printf "\n========= Start Demo_App ========================\n"

ruby -run -ehttpd . -p8000

