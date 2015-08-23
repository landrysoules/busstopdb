require 'spec_helper'
require 'busstopdb/data_builder'

describe Busstopdb do
  it 'has a version number' do
    expect(BusStopDB::VERSION).not_to be nil
  end
end

describe DataBuilder do
  it 'validates URLs' do
    data_builder = DataBuilder.new
    expect(data_builder.validate_urls(['http://google.com'])).to be true
    expect(data_builder.validate_urls(['http://goooogle.rs'])).to be false
  end
end
