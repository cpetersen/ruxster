require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ruxster::Vertex" do
  before(:all) do
    Ruxster::Config.connect_string = "http://localhost:8182/database"
    @vertex = Ruxster::Vertex.new("name" => "name_value")
  end

  it "should post to the proper url upon create" do
    Excon.should_receive(:post).with("http://localhost:8182/database/vertices?name=name_value")
    @vertex.create
  end

  it "should initialize properly from a hash" do
    @vertex["name"].should == "name_value"
  end

  describe "after create" do
    before(:all) do
      @original_vertex_count = Ruxster::Vertex.all.count
      @vertex.create
    end
    
    it "should add a vertex to the database" do
      Ruxster::Vertex.all.count.should == @original_vertex_count+1
    end
    
    it "should set the _id property after create" do
      @vertex["_id"].should_not be_nil
    end

    it "should set the _type property after create" do
      @vertex["_type"].should == "vertex"
    end
    
    it "should return the vertex when get is called" do
      vertex = Ruxster::Vertex.get(@vertex["_id"])
      vertex["_id"].should == @vertex["_id"]
      vertex["name"].should == @vertex["name"]
    end
    
    it "should update the database when update is called" do
      @vertex["name"] = "new_name"
      @vertex.update
      vertex = Ruxster::Vertex.get(@vertex["_id"])
      vertex["name"].should == "new_name"
    end
    
    it "should remove the vertex from the database when destroy is called" do
      vertex_count = Ruxster::Vertex.all.count
      @vertex.destroy
      Ruxster::Vertex.all.count.should == vertex_count-1
    end
  end

  it "should return all vertices in the database when all is called" do
    vertices = Ruxster::Vertex.all
    vertices.class.should == Array
  end
end
