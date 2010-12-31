libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)


module RubyRexster
  autoload :Base,   'ruby_rexster/base'
  autoload :Vertex, 'ruby_rexster/vertex'
  autoload :Edge,   'ruby_rexster/edge'

  class Config
    def self.connect_string=(value)
      @@connect_string = value
    end
    def self.connect_string
      @@connect_string
    end
  end
end
