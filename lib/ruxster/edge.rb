require 'excon'
require 'json'

module Ruxster  
  class Edge < Base
    def self.url_directory
      "edges"
    end
    def self.index_type
      "edge"
    end

    def initialize(hash={})
      hash.each do |key, value|
        case key.to_s
          when "id"
            self.id = value
          when "_id"
            self.id = value
          when "type"
            self.type = value
          when "_type"
            self.type = value
          when "_label"
            self.label = value
          when "label"
            self.label = value
          when "weight"
            self.weight = value
          when "_inV"
            self.in_vertex = value
          when "in_vertex"
            self.in_vertex = value
          when "_outV"
            self.out_vertex = value
          when "out_vertex"
            self.out_vertex = value
        end
      end
    end

    def label
      self.properties_hash["_label"]
    end
    def label=(value)
      self.properties_hash["_label"] = value
    end

    def weight
      self.properties_hash["weight"]
    end
    def weight=(value)
      self.properties_hash["weight"] = value.to_i
    end

    def in_vertex
      Vertex.get(self.properties_hash["_inV"])
    end
    def in_vertex=(value)
      if value.class == Vertex
        self.properties_hash["_inV"] = value["_id"]
      else
        self.properties_hash["_inV"] = value
      end
    end
    
    def out_vertex
      Vertex.get(self.properties_hash["_outV"])
    end
    def out_vertex=(value)
      if value.class == Vertex
        self.properties_hash["_outV"] = value["_id"]
      else
        self.properties_hash["_outV"] = value
      end
    end

    def self.create(hash={})
      edge = Edge.new(hash)
      edge.create
      edge
    end

    def self.all
      objects = []
      response = Excon.get(Vertex.connect_string + "/edges")
      if response
        results = JSON.parse(response.body)["results"]
        if results
          results.each do |hash|
            objects << self.new(hash)
          end
        end
      end
      objects
    end
  end
end
