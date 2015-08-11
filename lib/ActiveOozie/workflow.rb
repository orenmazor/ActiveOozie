require 'nokogiri'
require 'activeoozie/configuration'

module ActiveOozie
  class Workflow
    def initialize(client, name, path, email)
      @client = client
      @actions = []
      @path = path
      @name = name
      @notification_email = email
    end

    def add(action)
      @actions << action
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.send(:"workflow-app", name: @name, xmlns: "uri:oozie:workflow:0.5", 'xmlns:sla'=> 'uri:oozie:sla:0.2') do
          # the first action is the start
          xml.start(to: @actions.first.name)

          add_actions(xml)

          # print the notification action
          add_notify(xml)
          add_kill(xml)
          add_end(xml)
        end
      end

      builder.to_xml
    end

    def save!
      contents = to_xml
      @client.write(@path + @name, "workflow.xml", contents)
    end

    def submit!(run_now = false)
      configuration = ActiveOozie::Configuration.new({"user.name" => "oozie", "oozie.wf.application.path" => @path + @name}).to_xml

      @client.submit(configuration)
    end


    private

    def add_end(xml)
      xml.end(name: "end")
    end

    def add_actions(xml)
      #print all the actions
      @actions.each_with_index do |action, index|
        xml.action(name: action.name) do
          action.to_xml(xml)

          # note where we go next
          if index + 1 == @actions.size
            xml.ok(to: "end")
          else
            xml.ok(to: @actions[index+1].name)
          end

          xml.error(to: "notify")
        end
      end
    end

    def add_kill(xml)
      xml.kill(name: "kill") do
        xml.message("${wf:errorMessage(wf:lastErrorNode())}")
      end
    end

    def add_notify(xml)
      xml.action(name: "notify") do
        xml.email(xmlns: "uri:oozie:email-action:0.1") do
          xml.to do
            xml.text(@notification_email)
          end

          xml.subject do
            xml.text("WF ${wf:name()} failed")
          end

          xml.body do
            xml.text("${wf:errorMessage(wf:lastErrorNode())}")
          end
        end

        xml.ok(to: "kill")
        xml.error(to: "kill")
      end
    end
  end
end
