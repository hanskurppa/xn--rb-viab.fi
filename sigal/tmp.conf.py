# ln -s /var/www/html/tmp /var/www/sigal/destination_tmp
title = 'tmp'
source = 'source_tmp'
destination = 'destination_tmp'
theme = 'sigal-justlight'
use_orig = True
thumb_size = (320, 240)
thumb_fit = False
thumb_video_delay = '5'
orig_link = True
ignore_directories = []
ignore_files = []
video_format = 'mp4'
video_size = None
plugins = [ 'sigal.plugins.zip_gallery' ]
zip_gallery = '{album.name}.zip'
zip_media_format = 'orig'
zip_skip_if_exists = False
