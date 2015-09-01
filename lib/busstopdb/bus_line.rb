class BusLine
  attr_accessor :line_id, :line_name, :direction_a, :direction_r, :stations

  def initialize(line_id, line_name)
    @line_id = line_id
    @line_name = line_name
    @stations = []
  end

  def add_station(station_id, station_name)
    @stations << {station_id => station_name}
  end
end
