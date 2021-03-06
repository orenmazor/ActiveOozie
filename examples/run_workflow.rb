#!/usr/bin/env ruby

require 'ActiveOozie'
require 'uri'

# create the client that manages everything
client = ActiveOozie::Client.new(URI(ENV['WEBHDFS_URL']), URI(ENV['OOZIE_URL']))

# make a basic workflow that does stuff
wf = ActiveOozie::Workflow.new(client, "example", "/user/orenmazor/", "oren.mazor@gmail.com")
wf.add(ActiveOozie::Actions::Shell.new("foo", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))
wf.add(ActiveOozie::Actions::Shell.new("foo2", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))
wf.add(ActiveOozie::Actions::Shell.new("foo3", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))

wf.save!

wf.submit!





