#!/bin/bash
cd /var/www/html_sigal
MONITORDIR="/var/www/html_sigal/source_tmpk18/"
inotifywait -m -r -e create "${MONITORDIR}" | while read NEWFILE
do
    chronic sigal build -c sigal_tmpk18.conf.py
done
