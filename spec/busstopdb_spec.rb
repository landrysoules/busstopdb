require 'spec_helper'
require 'busstopdb/data_builder'

describe Busstopdb do
  it 'has a version number' do
    expect(BusStopDB::VERSION).not_to be nil
  end
end

describe DataBuilder do
  before (:each) do
    @data_builder = DataBuilder.new
  end

  it 'validates correct URLs' do
    expect(@data_builder.validate_urls(['http://google.com'])).to be true
  end

  it 'rejects wrong URLs' do
    expect(@data_builder.validate_urls(['http://goooogle.rs'])).to be false
  end

  it 'gets hash of bus lines' do
    expect(@data_builder.get_day_lines()).not_to be_empty
  end

  it 'gets list of bus lines/stations' do
    expect(@data_builder.get_day_stations()).not_to be_empty
  end
end
