require 'spec_helper'

describe Response do

  describe 'should merge errors with another object\'s activemodel::errors' do
    it '' do
      r = Response.new
      o = Response.new

      r.errors.add :some, 'error'
      o.merge_errors r.errors
      o.errors[:'Some'].should == ['error']
    end
    
    it 'when errors are stacked' do
      r = Response.new
      o = Response.new

      r.errors.add :some, 'error'
      r.errors.add :some, 'another error'
      o.merge_errors r.errors
      o.errors[:'Some'].should == ['error', 'another error']
    end
    
    it 'with an object name' do
      r = Response.new
      o = Response.new

      r.errors.add :somekey, 'error'
      o.merge_errors r.errors, object_name: 'some_object'
      o.errors[:'Somekey of the some_object'].should == ['error']
    end

    it 'with an empty object name' do
      r = Response.new
      o = Response.new

      r.errors.add :somekey, 'error'
      o.merge_errors r.errors, object_name: ''
      o.errors[:'Somekey'].should == ['error']
    end
  end    
end
