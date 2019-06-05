require 'spec_helper'

RSpec.describe 'Server Side Rendering' do
  it 'renders on the server' do
    doc = visit('/ssr')
    expect(doc.html).to include('Hello World!')
  end
end
