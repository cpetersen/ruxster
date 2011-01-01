require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ruxster" do
  it "should store the connect string" do
    Ruxster::Config.connect_string = "http://localhost:8182/database"
    Ruxster::Config.connect_string.should == "http://localhost:8182/database"
  end
end
