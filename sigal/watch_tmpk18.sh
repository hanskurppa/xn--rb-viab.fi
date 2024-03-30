#!/bin/bash
cd /var/www/sigal
MONITORDIR="/var/www/sigal/source_tmpk18/"
inotifywait -m -r -e create "${MONITORDIR}" | while read NEWFILE
do
    chronic sigal build -c tmpk18.conf.py
done
