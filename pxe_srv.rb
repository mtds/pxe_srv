#!/usr/bin/env ruby

require 'erb'
require 'pp'
require 'sinatra'
require 'yaml'

configure do
    if File.exists?('pxe_srv.yml')
       # Read the server config from a YAML file:
       yml_config=YAML.load_file('pxe_srv.yml')
       # Sets the document root for serving static files:
       set :public_dir, "\'#{yml_config['SrvConfig']['public_dir']}\'"
       # Sets the 'views' directory for erb templates:
       set :views, "\'#{yml_config['SrvConfig']['views']}\'"
       # Do not show exceptions
       set :show_exceptions, false
    else
       puts "'pxe_srv.yml' missing in the srv root directory! Exiting..."
       exit 1
    end
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

  # Extract the (fqdn) hostname from the HTTP request:
  remote_host = request.env['REMOTE_HOST']

  # Is there a symlink pointing to a specific file?
  if File.symlink?("static/#{remote_host}")
    File.delete("static/#{remote_host}")
    send_file('static/test')
  else
    send_file('static/menu.ipxe')
  end

end

#
# Installation with pxelinux
#

# Default route:
get '/pxelinux.cfg/default' do
end

# ERB template installation:
get '/pxelinux.cfg/:name' do
end

# Gracefully handle 404 errors:
not_found do
  "The requested route is not available"
end

