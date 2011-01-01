require 'excon'
require 'json'

module RubyRexster  
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
