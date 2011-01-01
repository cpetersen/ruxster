module RubyRexster
  class Base
    def initialize(hash={})
      hash.each { |k,v| properties_hash[k] = v }
    end    
    def parameterize
      URI.escape(properties_hash.collect{|k,v| "#{k}=#{v}"}.join('&'))
    end
    def properties_hash
      @properties_hash ||= {}
    end
    
    def id
      properties_hash["_id"]
    end
    def id=(value)
      properties_hash["_id"] = value
    end
    def type
      properties_hash["_type"]
    end
    def type=(value)
      properties_hash["_type"] = value
    end

    def self.connect_string
      RubyRexster::Config.connect_string
    end

    def self.get(id)
      object = nil
      response = Excon.get(Base.connect_string + "/#{self.url_directory}/#{id}")
      if response
        results = JSON.parse(response.body)["results"]
        object = self.new(results) if results
      end
      object
    end
    
    def create
      response = Excon.post(Base.connect_string + "/#{self.class.url_directory}?" + parameterize)
      if response
        results = JSON.parse(response.body)["results"]
        properties_hash["_id"] = results["_id"]
        properties_hash["_type"] = results["_type"]
      end
    end
    
    def update
      response = Excon.post(Base.connect_string + "/#{self.class.url_directory}/#{self.id}?" + parameterize)
    end
    
    def destroy
      response = Excon.delete(Base.connect_string + "/#{self.class.url_directory}/#{self.id}")
    end
  end
end
