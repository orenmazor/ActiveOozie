module ActiveOozie
  class Coordinator
    attr_reader :name
    attr_reader :path
    def initialize(client, path, name, starttime, endtime, frequency)
      @path = path + name
      @client = client
      @name = name
      @starttime = starttime.strftime("%Y-%m-%dT%H:%MZ")
      @endtime = endtime.strftime("%Y-%m-%dT%H:%MZ")
      @frequency_in_minutes = frequency
      @workflows = []
    end

    def add(wf)
      @workflows << wf
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.send(:"coordinator-app", xmlns:"uri:oozie:coordinator:0.2", timezone:"America/New_York", name: @name, start: @starttime, end: @endtime, frequency: @frequency_in_minutes) do
          add_controls(xml)

          xml.action do
            @workflows.each do |wf|
              xml.workflow do
                xml.send(:"app-path") do
                  xml.text(wf.path)
                end
              end
            end
          end
        end
      end

      builder.to_xml
    end

    def save!
      contents = to_xml
      @client.write(@path + @name, "coordinator.xml", contents)
    end

    def submit!
      configuration = ActiveOozie::Configuration.new({"user.name" => "oozie", "oozie.coord.application.path" => @path + @name}).to_xml

      @client.submit(configuration)
    end

    private 

    def add_controls(xml)
      xml.controls do
        xml.timeout do
          xml.text("600")
        end

        xml.concurrency do
          xml.text("1")
        end

        xml.execution do
          xml.text("FIFO")
        end

        xml.throttle do
          xml.text("1")
        end
      end
    end
  end
end
