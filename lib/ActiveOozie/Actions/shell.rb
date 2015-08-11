module ActiveOozie
  module Actions
    class Shell
      attr_reader :name

      def initialize(name, command, job_tracker, name_node, args= [])
        @name = name
        @command = command
        @arguments = args
        @job_tracker = job_tracker
        @name_node = name_node
      end

      def to_xml(nokogiri)
        nokogiri.shell(xmlns: "uri:oozie:shell-action:0.2") do
          nokogiri.send(:"job-tracker") do
            nokogiri.text(@job_tracker)
          end
          nokogiri.send(:"name-node") do
            nokogiri.text(@name_node)
          end
          nokogiri.exec do
            nokogiri.text(@command)
          end

          @arguments.each do |arg|
            nokogiri.argument do
              nokogiri.text(arg)
            end
          end
        end
      end
    end
  end
end
