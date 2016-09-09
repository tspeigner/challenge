require 'spec_helper'
describe 'pechallenge' do
  context 'with default values for all parameters' do
    it { should contain_class('pechallenge') }
  end
end
