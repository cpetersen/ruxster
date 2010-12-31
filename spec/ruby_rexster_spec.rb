require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyRexster" do
  it "should store the connect string" do
    RubyRexster::Config.connect_string = "http://localhost:8182/database"
    RubyRexster::Config.connect_string.should == "http://localhost:8182/database"
  end
end
