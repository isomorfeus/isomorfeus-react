require 'spec_helper'

RSpec.describe 'Server Side Rendering' do
  before do
    @doc = visit('/ssr')
  end
  it 'renders on the server' do
    skip unless React.server_side_rendering
    expect(@doc.html).to include('Rendered!')
  end

  it 'it returns 404 if page not found' do
    skip unless React.server_side_rendering
    @doc = visit('/whatever')
    expect(@doc.response.status).to eq(404)
  end
end
