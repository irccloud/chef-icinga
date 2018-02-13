name             'icinga'
maintainer       'Irccloud Ltd.'
chef_version      '>= 12.5'
maintainer_email 'russ@garrett.co.uk'
license          'All rights reserved'
description      'Installs/Configures icinga'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.8'

depends "apache2"
