#!/usr/bin/env ruby

require 'time'
require 'ActiveOozie'
require 'uri'

# create the client that manages everything
client = ActiveOozie::Client.new(URI(ENV['WEBHDFS_URL']), URI(ENV['OOZIE_URL']))

# make a basic workflow that does stuff
wf = ActiveOozie::Workflow.new(client, "example-coordinator", "/user/orenmazor/", "oren.mazor@gmail.com")
wf.add(ActiveOozie::Actions::Shell.new("foo", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))
wf.add(ActiveOozie::Actions::Shell.new("foo2", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))
wf.add(ActiveOozie::Actions::Shell.new("foo3", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))

wf.save!

# create a coordinator to run the above once an hour from now until 20 days from now
coord = ActiveOozie::Coordinator.new(client, "/user/orenmazor/", "example-coordinator", Time.now, Time.now + (60 * 60 * 24 * 20), 60)
coord.add(wf)

coord.save!
coord.submit!




