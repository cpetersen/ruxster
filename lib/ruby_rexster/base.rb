module RubyRexster  
  class Base
    def server_url
      @server_url ||= "http://localhost:8182"
      @server_url
    end
    def server_url=(value)
      @server_url = value
    end
  end
end
