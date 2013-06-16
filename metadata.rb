name             'kdeploy'
maintainer       'Roderik van der Veer'
maintainer_email 'roderik.van.der.veer@kunstmaan.be'
license          'All rights reserved'
description      'Installs/Configures kdeploy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'ubuntu'


depends          "build-essential"
depends          "ssh_known_hosts"
depends          "root_ssh_agent"
