#!/usr/bin/env bash

printf "========= Install Development tools ===============\n"
yum groups mark convert "Development Tools"
yum group install "Development Tools" -y
yum install gettext-devel perl-CPAN perl-devel zlib-devel nano expect tcl -y
