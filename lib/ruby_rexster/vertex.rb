require 'excon'
require 'json'

module RubyRexster  
  class Vertex < Base
    def self.get(id)
      vertex = nil
      response = Excon.get(Vertex.connect_string + "/vertices/#{id}")
      if response
        results = JSON.parse(response.body)["results"]
        vertex = Vertex.new(results) if results
      end
      vertex
    end
    
    def create
      response = Excon.post(Vertex.connect_string + "/vertices?" + parameterize)
      if response
        results = JSON.parse(response.body)["results"]
        self["_id"] = results["_id"]
        self["_type"] = results["_type"]
      end
    end
    
    def update
      response = Excon.post(Vertex.connect_string + "/vertices/#{self["_id"]}?" + parameterize)
    end
    
    def destroy
      response = Excon.delete(Vertex.connect_string + "/vertices/#{self["_id"]}")
    end
    
    def self.all
      vertices = []
      response = Excon.get(Vertex.connect_string + "/vertices")
      if response
        results = JSON.parse(response.body)["results"]
        if results
          results.each do |hash|
            vertices << Vertex.new(hash)
          end
        end
      end
      vertices
    end
  end
end
