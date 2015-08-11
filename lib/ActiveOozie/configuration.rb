require 'nokogiri'

module ActiveOozie
  class Configuration
    def initialize(properties)
      @properties = properties
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.configuration do
          @properties.each do |(name, value)|
            xml.property do
              xml.name do
                xml.text(name)
              end

              xml.value do
                xml.text(value)
              end
            end
          end
        end

      end

      builder.to_xml
    end
  end
end
