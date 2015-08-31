#!/bin/bash
eval $(/usr/local/bin/metadatavars)
eval $(/usr/local/bin/userdata)
/opt/Prana/bin/Prana -c /etc/prana/prana.properties 2>&1 | logger -t "prana"