libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)


module RubyRexster
  autoload :Vertex, 'ruby_rexster/vertex'
  autoload :Edge,   'ruby_rexster/edge'
end
