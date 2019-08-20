require 'spec_helper'

RSpec.describe 'Execution Environment' do
  before do
    @doc = visit('/')
  end

  it 'is set to "production"' do
    result = @doc.evaluate_ruby do
      Isomorfeus.env
    end
    expect(result).to eq('production')
    result = @doc.evaluate_ruby do
      Isomorfeus.production?
    end
    expect(result).to be true
    result = @doc.evaluate_ruby do
      Isomorfeus.development?
    end
    expect(result).to be false
  end

  it 'detects browser' do
    result = @doc.evaluate_ruby do
      Isomorfeus.on_browser?
    end
    expect(result).to be true
    result = @doc.evaluate_ruby do
      Isomorfeus.on_ssr?
    end
    expect(result).to be false
  end
end
