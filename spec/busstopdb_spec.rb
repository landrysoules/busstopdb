require 'spec_helper'
require 'busstopdb/data_builder'
require 'busstopdb/bus_line'
require 'rest-client'

describe Busstopdb do
  it 'has a version number' do
    expect(BusStopDB::VERSION).not_to be nil
  end
end

describe DataBuilder do
  before (:each) do
    @data_builder = DataBuilder.new
  end
  # TODO: These are actually integration tests => rewrite true unit tests (by mocking restClient for example)
  it 'validates correct URLs' do
    expect(@data_builder.validate_urls(['http://google.com'])).to be true
  end

  it 'rejects wrong URLs' do
    expect(@data_builder.validate_urls(['http://goooogle.rs'])).to be false
  end

  it 'gets hash of bus lines' do
    expect(@data_builder.get_day_lines()).not_to be_empty
  end

  it 'gets list of bus stations' do
    expect(RestClient).to receive(:post).with(any_args).and_return(open(File.expand_path("../stations.html",__FILE__)))
    bus_line = @data_builder.get_stations(BusLine.new('B206', 206))
    expect(bus_line.stations).not_to be_empty
    expect(bus_line.stations[0].keys[0]).to eql('206_216_217')
    expect(bus_line.stations[bus_line.stations.size - 1].keys[0]).to eql('206_303_304')
  end
end
