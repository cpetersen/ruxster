require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyRexster::Base" do
  before(:all) do
    RubyRexster::Config.connect_string = "http://localhost:8182/database"
    @base = RubyRexster::Base.new("_id" => "id", "name" => "name_value", "rank" => 5)
  end

  it "should initialize properly from a hash" do
    @base["_id"].should == "id"
    @base["name"].should == "name_value"
    @base["rank"].should == 5
  end

  it "should have the connect string" do
    RubyRexster::Base.connect_string.should == "http://localhost:8182/database"
  end
  
  it "should properly encode it's parameters" do
    @base.parameterize.should == "name=name_value&_id=id&rank=5"
  end
end
