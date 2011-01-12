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

  it "should add a vertex when Class.create is called" do
    original_vertex_count = Ruxster::Vertex.all.count
    Ruxster::Vertex.create("name" => "name_value")
    Ruxster::Vertex.all.count.should == original_vertex_count+1
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
  
  describe "a small network of 3 vertices and 4 edges" do
    before(:all) do
      @jack = Ruxster::Vertex.create("name" => "Jack")
      @jill = Ruxster::Vertex.create("name" => "Jill")
      @tommy_boy = Ruxster::Vertex.create("name" => "Tommy Boy")
      @jack_clicked_tommy_boy = Ruxster::Edge.create("_label" => "clicked", "weight" => 15, :in_vertex => @tommy_boy, :out_vertex => @jack)
      @jill_clicked_tommy_boy = Ruxster::Edge.create("_label" => "clicked", "weight" => 15, :in_vertex => @tommy_boy, :out_vertex => @jill)
      @jack_bought_tommy_boy = Ruxster::Edge.create("_label" => "bought", "weight" => 15, :in_vertex => @tommy_boy, :out_vertex => @jack)
      @jill_likes_jack = Ruxster::Edge.create("_label" => "likes", "weight" => 15, :in_vertex => @jack, :out_vertex => @jill)
    end
    
    it "Tommy Boy should have 3 In Edges" do
      @tommy_boy.in_edges.count.should == 3
    end
    it "Jack should have 2 Out Edges" do
      @jack.out_edges.count.should == 2
    end
    it "Jack should have 3 Total Edges" do
      @jack.all_edges.count.should == 3
    end

    it "find the right vertex" do
      results = Ruxster::Vertex.find("name", "Jack")
      results.first["name"].should == "Jack"
    end
  end

  it "should return all vertices in the database when all is called" do
    vertices = Ruxster::Vertex.all
    vertices.class.should == Array
  end
end
