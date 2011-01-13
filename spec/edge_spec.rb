require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ruxster::Edge" do
  before(:all) do
    Ruxster::Config.connect_string = "http://localhost:8182/database"
    @vertex1 = Ruxster::Vertex.create("name" => "Vertex 1")
    @vertex2 = Ruxster::Vertex.create("name" => "Vertex 2")
    @edge = Ruxster::Edge.new("_label" => "label", "weight" => 15)
  end

  it "should initialize properly from a hash" do
    @edge.label.should == "label"
    @edge.weight.should == 15
  end

  it "it should set _inV when in_vertex is called" do
    @edge.in_vertex = @vertex1
    @edge.properties_hash["_inV"].should == @vertex1.id
    @edge.in_vertex.id.should == @vertex1.id
  end

  it "it should set _outV when out_vertex is called" do
    @edge.out_vertex = @vertex2
    @edge.properties_hash["_outV"].should == @vertex2.id
    @edge.out_vertex.id.should == @vertex2.id
  end

  it "it should set label properly" do
    @edge.label = "label"
    @edge.properties_hash["_label"].should == "label"
    @edge.label.should == "label"
  end

  it "it should set weight properly" do
    @edge.weight = 15
    @edge.properties_hash["weight"].should == 15
    @edge.weight.should == 15
  end

  it "it should set weight properly when using a string" do
    @edge.weight = "15"
    @edge.properties_hash["weight"].should == 15
    @edge.weight.should == 15
  end

  it "it should set weight properly when passed nil" do
    @edge.weight = nil
    @edge.properties_hash["weight"].should == 0
    @edge.weight.should == 0
  end

  it "should post to the proper url upon create" do
    edge = Ruxster::Edge.new("_label" => "label", "weight" => 15, :in_vertex => @vertex1, :out_vertex => @vertex2)
    Excon.should_receive(:post).with("http://localhost:8182/database/edges?_label=label&weight=15&_outV=#{@vertex2.id}&_inV=#{@vertex1.id}")
    edge.create
  end
  
  it "should add a vertex when Class.create is called" do
    original_vertex_count = Ruxster::Edge.all.count
    Ruxster::Edge.create("label" => "label_value", :in_vertex => @vertex1, :out_vertex => @vertex2)
    Ruxster::Edge.all.count.should == original_vertex_count+1
  end
  
  it "find the right edge" do
    results = Ruxster::Edge.find("weight", 15)
    results.first["weight"].should == "15"
  end
  
  describe "after create" do
    before(:all) do
      @original_edge_count = Ruxster::Edge.all.count
      @edge.in_vertex = @vertex1
      @edge.out_vertex = @vertex2
      @edge.create
    end
    
    it "should add a edge to the database" do
      Ruxster::Edge.all.count.should == @original_edge_count+1
    end
  
    it "should set the _id property after create" do
      @edge.id.should_not be_nil
    end
  
    it "should set the _type property after create" do
      @edge.type.should == "edge"
    end
    
    it "should return the edge when get is called" do
      edge = Ruxster::Edge.get(@edge.id)
      edge.id.should == @edge.id
    end
    
    it "should update the database when update is called" do
      @edge.weight = 25
      @edge.update
      edge = Ruxster::Edge.get(@edge.id)
      edge.weight.should == 25
    end

    it "should update the database when weight is updated to nil" do
      @edge.weight = nil
      @edge.update
      edge = Ruxster::Edge.get(@edge.id)
      edge.weight.should == 0
    end
    
    it "should remove the edge from the database when destroy is called" do
      edge_count = Ruxster::Edge.all.count
      @edge.destroy
      Ruxster::Edge.all.count.should == edge_count-1
    end
  end
  
  it "should return all edges in the database when all is called" do
    edges = Ruxster::Edge.all
    edges.class.should == Array
  end

  it "should post to the proper url when creating the edge index" do
    Excon.should_receive(:post).with("http://localhost:8182/database/indices/index?class=edge&type=automatic")
    Ruxster::Edge.create_index    
  end
  
  it "should return an array of hashes when Edge.indices is called" do
    Ruxster::Edge.create_index    
    indices = Ruxster::Edge.indices
    indices.should include({"name" => "edges","class" => "com.tinkerpop.blueprints.pgm.impls.neo4j.Neo4jEdge","type" => "automatic"})
  end
end
