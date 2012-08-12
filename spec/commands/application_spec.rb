require 'network_executive/commands/application'

describe NetworkExecutive::Application do
  it 'should require a path' do
    expect { described_class.new }.to raise_error( ArgumentError )
  end

  it 'should create an new application in the specified path' do
    described_class.new( '.' ).should be_a described_class
  end
end