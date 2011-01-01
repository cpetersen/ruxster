require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyRexster::Base" do
  before(:all) do
    RubyRexster::Config.connect_string = "http://localhost:8182/database"
  end

  it "should have the connect string" do
    RubyRexster::Base.connect_string.should == "http://localhost:8182/database"
  end

  it "should have a property_hash" do
    RubyRexster::Base.new.properties_hash.should == {}
  end
  it "should properly set id" do
    base = RubyRexster::Base.new
    base.id = "id"
    base.properties_hash["_id"].should == "id"
    base.id.should == "id"
  end
  it "should properly set type" do
    base = RubyRexster::Base.new
    base.type = "type"
    base.properties_hash["_type"].should == "type"
    base.type.should == "type"
  end

  it "should initialize properly from a hash" do
    base = RubyRexster::Base.new("_id" => "id", "name" => "name_value", "rank" => 5)
    base.properties_hash["_id"].should == "id"
    base.properties_hash["name"].should == "name_value"
    base.properties_hash["rank"].should == 5
  end
  
  it "should properly encode it's parameters" do
    base = RubyRexster::Base.new("_id" => "id", "name" => "name_value", "rank" => 5)
    base.parameterize.should == "name=name_value&_id=id&rank=5"
  end
end
