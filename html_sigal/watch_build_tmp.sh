#!/bin/bash
cd /var/www/html_sigal
MONITORDIR="/var/www/html_sigal/source/"
inotifywait -m -r -e create "${MONITORDIR}" | while read NEWFILE
do
    chronic sigal build -c sigal_tmp.conf.py
done
