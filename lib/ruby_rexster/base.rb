module RubyRexster
  class Base < Hash
    def initialize(hash={})
      hash.each { |k,v| self[k] = v }
    end
    
    def parameterize
      URI.escape(self.collect{|k,v| "#{k}=#{v}"}.join('&'))
    end

    def self.connect_string
      RubyRexster::Config.connect_string
    end
  end
end
