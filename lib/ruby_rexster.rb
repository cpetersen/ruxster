libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'ruby_rexster/vertex'
require 'ruby_rexster/edge'

module RubyRexster
end
