require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyRexster::Vertex" do
  before(:all) do
    RubyRexster::Config.connect_string = "http://localhost:8182/database"
    @vertex = RubyRexster::Vertex.new
    @vertex["name"] = "name_value"
  end

  it "should post to the proper url upon create" do
    Excon.should_receive(:post).with("http://localhost:8182/database/vertices?name=name_value")
    @vertex.create
  end

  it "should add a vertex to the database" do
    vertex_count = RubyRexster::Vertex.all.count
    @vertex.create
    RubyRexster::Vertex.all.count.should == vertex_count+1
  end

  it "should set the _id property after create" do
    @vertex.create
    @vertex["_id"].should_not be_nil
  end

  it "should set the _type property after create" do
    @vertex.create
    @vertex["_type"].should == "vertex"
  end

  it "should return all vertices in the database when all is called" do
    vertices = RubyRexster::Vertex.all
    vertices.class.should == Array
  end
end
