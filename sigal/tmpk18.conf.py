# ln -s /var/www/html/tmpk18 /var/www/sigal/destination_tmpk18
title = 'tmpk18'
source = 'source_tmpk18'
destination = 'destination_tmpk18'
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
