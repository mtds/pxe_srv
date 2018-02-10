#!/usr/bin/env ruby

require 'erb'
require 'pathname'
require 'pp'
require 'sinatra'
require 'yaml'

configure do
  if File.exists?('pxe_srv.yml')
     # Read the server config from a YAML file:
     yml_config=YAML.load_file('pxe_srv.yml')
     # Sets the document root for serving static files:
     set :public_dir, "#{yml_config['SrvConfig']['public_dir']}"
     # Sets the 'views' directory for erb templates:
     set :views, "#{yml_config['SrvConfig']['views']}"
     # Do not show exceptions
     set :show_exceptions, false
  else
    puts "'pxe_srv.yml' missing in the srv root directory! Exiting..."
    exit 1
  end
  # Log to file (ref: http://recipes.sinatrarb.com/p/middleware/rack_commonlogger)
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

# Server will always return contents in text format:
before do
  content_type :txt
end

#
# Installation with iPXE 
#

# Basic route name as configured in the 'Filename' option on the DHCP server.
get '/menu' do

  # Extract the IP of the hostname from the HTTP request:
  remote_host_ip = request.env['REMOTE_HOST']

  # Build the symlink string:
  symlink_pxe = settings.public_dir + "/#{remote_host_ip}"

  # Verify whether the symlink exist and it's not broken:
  if File.exist?(symlink_pxe) && File.symlink?(symlink_pxe)
    # Extract the filename pointed by the symlink:
    pxefile = File.readlink(Pathname.new(symlink_pxe).expand_path)
    File.delete(symlink_pxe) # remove the symlink
    send_file(settings.public_dir + '/' + pxefile)
  else
    # When there's no symlink for the host contacting this server, then always
    # return a default iPXE file:
    send_file(settings.public_dir + '/menu.ipxe')
  end

end

#
# Installation with pxelinux
#

# Default route:
get '/pxelinux.cfg/default' do
  send_file(settings.public_dir + '/pxelinux.cfg/default')
end

# ERB template installation:
get '/pxelinux.cfg/:name' do
end

# Gracefully handle 404 errors:
not_found do
  "The requested route is not available"
end

