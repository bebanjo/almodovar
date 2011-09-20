require 'spec_helper'

describe "Almodovar::Resource#collection_call?" do
  
  let(:resource) { Almodovar::Resource.new(nil, nil) }
  
  it "should be true for size" do
    resource.send(:collection_call?, :size).should be_true
  end
  
  it "should be true for first" do
    resource.send(:collection_call?, :first).should be_true
  end
  
  it "should be true for last" do
    resource.send(:collection_call?, :last).should be_true
  end
  
  it "should be true for [n]" do
    resource.send(:collection_call?, :[], 1).should be_true
  end
  
  it "should be true for create" do
    resource.send(:collection_call?, :create).should be_true
  end
  
  it "should be false for ['string']" do
    resource.send(:collection_call?, :[], 'string').should be_false
  end
  
  it "should be false for [:s]" do
    resource.send(:collection_call?, :[], :symbol).should be_false
  end
  
  it "should be false for id" do
    resource.send(:collection_call?, :id).should be_false
  end
  
  it "should be false for delete" do
    resource.send(:collection_call?, :delete).should be_false
  end
end
