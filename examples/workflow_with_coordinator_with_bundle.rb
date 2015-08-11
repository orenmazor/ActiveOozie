#!/usr/bin/env ruby

require 'time'
require 'ActiveOozie'
require 'ActiveOozie/Workflow'
require 'ActiveOozie/Coordinator'
require 'ActiveOozie/Bundle'
require 'ActiveOozie/Actions/Shell'
require 'uri'

# create the client that manages everything
client = ActiveOozie::Client.new(URI(ENV['OOZIE_URL']), URI(ENV['WEBHDFS_URL']))

# make a basic workflow that does stuff
wf = ActiveOozie::Workflow.new(client, "example", "/user/orenmazor/", "oren.mazor@gmail.com")
wf.add(ActiveOozie::Actions::Shell.new("foo", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))
wf.add(ActiveOozie::Actions::Shell.new("foo2", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))
wf.add(ActiveOozie::Actions::Shell.new("foo3", "whoami", ENV['RESOURCE_MANAGER'], ENV['NAMENODE']))

wf.save!

# create a coordinator to run the above once an hour from now until 20 days from now
coord = ActiveOozie::Coordinator.new(client, "/user/orenmazor/", "example", Time.now, Time.now + (60 * 60 * 24 * 20), 60)
coord.add(wf)

coord.save!

# create a bundle to RULE THEM ALL

bundle = ActiveOozie::Bundle.new(client, "/user/orenmazor/", "example")
bundle.add(coord)
bundle.save!
bundle.submit!


