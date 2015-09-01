require 'open-uri'
require 'couchrest'
require 'nokogiri'
require 'rest-client'
require 'busstopdb/bus_line'

class DataBuilder
  include Busstopdb

  attr_reader :day_lines

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
    # FIXME: @day_lines doit être un hash de BusLine objects, avec comme clé l'id de la ligne, de manière à y accéder rapidement
    doc = Nokogiri::HTML(RestClient.get("http://www.ratp.fr/horaires/fr/ratp/bus"))
    line_options = doc.css("select#busLigneServiceForm_line option")
    line_options.each do |line_option|
      val = line_option.attribute('value').value
      unless val == 'null'
        Log.info(val)
        Log.info(line_option.text)
        @day_lines[val] = BusLine.new(val, line_option.text)
      end
    end
    #Log.debug(@day_lines)
    return @day_lines
  end

  def get_stations(bus_line)
    doc = Nokogiri::HTML(RestClient.post("http://www.ratp.fr/horaires/fr/ratp/bus", 'busLigneServiceForm[service]' => 'B', 
                                         'busLigneServiceForm[line]' => bus_line.line_name, 
                                         'autocomplete_busLigneServiceForm' => bus_line.line_id, 
                                         'autocomplete_noctilienLigneServiceForm[line]'=> bus_line.line_id,
                                         'noctilienLigneServiceForm[service]' => 'PP'))
    stations_options = doc.css("select#busArretDirectionForm_station option")
    stations_options.each do |station_option|
      val = station_option.attribute('value').value
      unless val == 'null'
        Log.info(val)
        Log.info(station_option.text)
        bus_line.add_station(val, station_option.text)
      end
    end
    return bus_line
  end
end
