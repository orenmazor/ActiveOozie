module ActiveOozie
  class Bundle
    def initialize(client, path, name)
      @client = client
      @path = path + name
      @name = name
      @coords = []
    end

    def add(coord)
      @coords << coord
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.send(:"bundle-app", name: @name, xmlns: "uri:oozie:bundle:0.1") do
          @coords.each do |coord|
            xml.coordinator(name: coord.name) do
              xml.send(:"app-path") do
                xml.text(coord.path)
              end
            end
          end
        end
      end

      builder.to_xml
    end

    def save!
      contents = to_xml
      @client.write(@path + @name, "bundle.xml", contents) 
    end

    def submit!
      configuration = ActiveOozie::Configuration.new({"user.name" => "oozie", "oozie.bundle.application.path" => @path + @name}).to_xml

      @client.submit(configuration)
    end
  end
end
