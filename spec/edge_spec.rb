require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyRexster::Edge" do
  before(:all) do
    RubyRexster::Config.connect_string = "http://localhost:8182/database"
    @vertex1 = RubyRexster::Vertex.new("name" => "Vertex 1")
    @vertex1.create
    @vertex2 = RubyRexster::Vertex.new("name" => "Vertex 2")
    @vertex2.create
    @edge = RubyRexster::Edge.new("_label" => "label", "weight" => 15)
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
    edge = RubyRexster::Edge.new("_label" => "label", "weight" => 15, :in_vertex => @vertex1, :out_vertex => @vertex2)
    Excon.should_receive(:post).with("http://localhost:8182/database/edges?_label=label&weight=15&_outV=#{@vertex2.id}&_inV=#{@vertex1.id}")
    edge.create
  end
  
  describe "after create" do
    before(:all) do
      @original_edge_count = RubyRexster::Edge.all.count
      @edge.in_vertex = @vertex1
      @edge.out_vertex = @vertex2
      @edge.create
    end
    
    it "should add a edge to the database" do
      RubyRexster::Edge.all.count.should == @original_edge_count+1
    end
  
    it "should set the _id property after create" do
      @edge.id.should_not be_nil
    end
  
    it "should set the _type property after create" do
      @edge.type.should == "edge"
    end
    
    it "should return the edge when get is called" do
      edge = RubyRexster::Edge.get(@edge.id)
      edge.id.should == @edge.id
    end
    
    it "should update the database when update is called" do
      @edge.weight = 25
      @edge.update
      edge = RubyRexster::Edge.get(@edge.id)
      edge.weight.should == 25
    end

    it "should update the database when weight is updated to nil" do
      @edge.weight = nil
      @edge.update
      edge = RubyRexster::Edge.get(@edge.id)
      edge.weight.should == 0
    end
    
    it "should remove the edge from the database when destroy is called" do
      edge_count = RubyRexster::Edge.all.count
      @edge.destroy
      RubyRexster::Edge.all.count.should == edge_count-1
    end
  end
  
  it "should return all edges in the database when all is called" do
    edges = RubyRexster::Edge.all
    edges.class.should == Array
  end
end
