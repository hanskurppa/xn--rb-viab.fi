#!/bin/bash
cd /var/www/sigal
MONITORDIR="/var/www/sigal/source_tmp/"
inotifywait -m -r -e create "${MONITORDIR}" | while read NEWFILE
do
    chronic sigal build -c tmp.conf.py
done
