libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)


module Ruxster
  autoload :Base,   'ruxster/base'
  autoload :Vertex, 'ruxster/vertex'
  autoload :Edge,   'ruxster/edge'

  class Config
    def self.connect_string=(value)
      @@connect_string = value
    end
    def self.connect_string
      @@connect_string
    end
  end
end
