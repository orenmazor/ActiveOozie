#!/usr/bin/env ruby

require 'ActiveOozie'
require 'uri'

# create the client that manages everything
client = ActiveOozie::Client.new(URI(ENV['WEBHDFS_URL']), URI(ENV['OOZIE_URL']))

puts client.bundles
