require 'spec_init'

RSpec.describe Flow do
  it 'ensures that we have at least 2 expiriences' do
    expect(FlowExperience.all.length > 1).to be(true)
  end

  it 'ensures that we have all the keys that we need' do
    exp = FlowExperience.all.first

    expect(exp.name.length > 3).to be(true)
    expect(exp.region.id.length).to eq(3)
  end

  it 'ensures we can fetch flow api data' do
    data = FlowRoot.api(:get, '/geolocation/defaults', ip: '192.206.151.131')
    expect(data[0]['country']).to eq('CAN')
  end
end
