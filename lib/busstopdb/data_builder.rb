require 'open-uri'
require 'couchrest'
require 'nokogiri'

class DataBuilder
  include Busstopdb
  def validate_urls(urls)
    urls.each do |url|
      begin
        open url
      rescue SocketError
        Log.error("Wrong URL #{url}: #{$!}")
        return false
      end
    end
    return true
  end

  def get_day_lines()
    @day_lines = {}
    doc = Nokogiri::HTML(open("http://www.ratp.fr/horaires/fr/ratp/bus"))
    line_options = doc.css("select#busLigneServiceForm_line option")
    line_options.each do |line_option|
      val = line_option.attribute('value').value
      unless val == 'null'
        Log.info(val)
        Log.info(line_option.text)
        @day_lines[val] = line_option.text
      end
    end
    Log.debug(@day_lines)
    return @day_lines
  end
end
