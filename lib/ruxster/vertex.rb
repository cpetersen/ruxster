require 'excon'
require 'json'

module Ruxster  
  class Vertex < Base
    def self.url_directory
      "vertices"
    end

    def [](key)
      properties_hash[key]
    end
    def []=(key, value)
      properties_hash[key] = value
    end

    def out_edges
      all_edges("outE")
    end
    def in_edges
      all_edges("inE")
    end
    def all_edges(which_edges="bothE")
      edges = []
      response = Excon.get(Vertex.connect_string + "/vertices/#{self.id}/#{which_edges}")
      if response
        results = JSON.parse(response.body)["results"]
        if results
          results.each do |hash|
            edges << Edge.new(hash)
          end
        end
      end
      edges
    end

    def self.create(hash={})
      edge = Vertex.new(hash)
      edge.create
      edge
    end
    
    def self.all
      objects = []
      response = Excon.get(Vertex.connect_string + "/vertices")
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
