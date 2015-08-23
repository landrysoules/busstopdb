require 'open-uri'
require 'logger'
require 'couchrest'

class DataBuilder

  def validate_urls(urls)
  @logger = Logger.new(STDOUT)
    urls.each do |url|
      begin
        open url
      rescue SocketError
        @logger.error("Wrong URL #{url}: #{$!}")
        return false
      end
    end
    return true
  end
end
