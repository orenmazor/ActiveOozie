require "ActiveOozie/version"
require 'webhdfs'
require 'rest-client'

require 'byebug'

module ActiveOozie
  class Client
    def initialize(hdfs_uri, oozie_uri)
      @fs = WebHDFS::Client.new(hdfs_uri.hostname, hdfs_uri.port, hdfs_uri.user)
      @oozie = oozie_uri
    end

    def write(path, filename, contents)
      @fs.mkdir(path)
      @fs.create("#{path}/#{filename}", contents)
    end

    def submit(configuration, run = true)
      uri = @oozie.to_s + "/oozie/v1/jobs"
      if run
        uri += "?action=start"
      end

      begin
        response = RestClient.post(uri, configuration, {"Content-Type" => "application/xml"})
        puts "[#{response.code}] #{response.body}"
      rescue RestClient::ExceptionWithResponse => err
        puts err.response.headers[:oozie_error_code]
        puts err.response.headers[:oozie_error_message]

        puts err.response.body
      end
    end
  end
end
