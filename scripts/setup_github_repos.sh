#!/bin/bash

# Personal
git clone git@github.com:bjarnehelland/dotfiles.git ~/Code/bjarnehelland/dotfiles
git clone git@github.com:bjarnehelland/100ord.git ~/Code/bjarnehelland/100ord

zoxide add ~/Code/bjarnehelland/dotfiles
zoxide add ~/Code/bjarnehelland/100ord

# Stacc
git clone git@github.com:stacc/bolig-opf.git ~/Code/stacc/bolig-opf
git clone git@github.com:stacc/bolig-lba.git ~/Code/stacc/bolig-lba
git clone git@github.com:stacc/bolig-min-side.git ~/Code/stacc/bolig-min-side
git clone git@github.com:stacc/intrum.git ~/Code/stacc/intrum
git clone git@github.com:stacc/services-integration-proxy.git ~/Code/stacc/services-integration-proxy
git clone git@github.com:stacc/express-sbl.git ~/Code/stacc/express-sbl
git clone git@github.com:stacc/express-filescan.git ~/Code/stacc/express-filescan
git clone git@github.com:stacc/environments.git ~/Code/stacc/environments
git clone git@github.com:stacc/flow.git ~/Code/stacc/flow
git clone git@github.com:stacc/blocc.git ~/Code/stacc/blocc

zoxide add ~/Code/stacc/bolig-opf
zoxide add ~/Code/stacc/bolig-lba
zoxide add ~/Code/stacc/bolig-min-side
zoxide add ~/Code/stacc/intrum
zoxide add ~/Code/stacc/services-integration-proxy
zoxide add ~/Code/stacc/express-sbl
zoxide add ~/Code/stacc/express-filescan
zoxide add ~/Code/stacc/environments
zoxide add ~/Code/stacc/flow
zoxide add ~/Code/stacc/blocc
