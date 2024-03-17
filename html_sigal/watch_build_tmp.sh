#!/bin/bash
cd /var/www/html_sigal
source sigal/bin/activate
MONITORDIR="/var/www/html_sigal/source_tmp/"
inotifywait -m -r -e create "${MONITORDIR}" | while read NEWFILE
do
    chronic sigal build -c sigal_tmp.conf.py
done
