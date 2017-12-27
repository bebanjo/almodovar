require 'spec_helper'

describe "Almodovar::Resource#collection_call?" do

  let(:resource) { Almodovar::Resource.new(nil, nil) }

  it "should be true for size" do
    expect(resource.send(:collection_call?, :size)).to be true
  end

  it "should be true for first" do
    expect(resource.send(:collection_call?, :first)).to be true
  end

  it "should be true for last" do
    expect(resource.send(:collection_call?, :last)).to be true
  end

  it "should be true for [n]" do
    expect(resource.send(:collection_call?, :[], 1)).to be true
  end

  it "should be true for create" do
    expect(resource.send(:collection_call?, :create)).to be true
  end

  it "should be false for ['string']" do
    expect(resource.send(:collection_call?, :[], 'string')).to be false
  end

  it "should be false for [:s]" do
    expect(resource.send(:collection_call?, :[], :symbol)).to be false
  end

  it "should be false for id" do
    expect(resource.send(:collection_call?, :id)).to be false
  end

  it "should be false for delete" do
    expect(resource.send(:collection_call?, :delete)).to be false
  end
end
