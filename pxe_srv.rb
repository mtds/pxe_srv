#!/usr/bin/env ruby

require 'erb'
require 'pp'
require 'sinatra'

configure do
    # Sets the document root for serving static files:
    set :public_dir, '/home/dessalvi/src/Ruby/Sinatra_tests/PXE_Srv/static'
    # Sets the 'views' directory for erb templates:
    set :views, '/home/dessalvi/src/Ruby/Sinatra_tests/PXE_srv/views'
    # Do not show exceptions
    set :show_exceptions, false
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

  # if there's a symlink (IP from the machine) to a different file will serve that one
  # otherwise will get to the default 'boot from disk'.

  # Extract the (fqdn) hostname from the HTTP request:
  remote_host = request.env['REMOTE_HOST']

  if File.symlink?("static/#{remote_host}")
    send_file('static/test')
    File.delete("static/#{remote_host}")
  else
    send_file('static/menu.ipxe')
  end

  # Grab the hostname and remove the domain name:
  #pp request.env['REMOTE_HOST'].split(".")[0]

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

