$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'forwardable'
gem 'oauth', '>= 0.3.5'
require 'oauth'
gem 'jordi-xml-object', '>= 0.9.91'
require 'xml-object'                  



module LinkedIn
  VERSION = '0.0.21'
  
  class LinkedInError < StandardError; end  
  class Unauthorized  < LinkedInError; end
  class General       < LinkedInError; end
  class Unavailable   < StandardError; end
  class NotFound      < StandardError; end  
  class Forbidden     < StandardError; end  
  
  autoload :Base, File.join(File.dirname(__FILE__), *%w[linked_in base.rb])
  autoload :OAuth, File.join(File.dirname(__FILE__), *%w[linked_in oauth.rb])
  autoload :Request, File.join(File.dirname(__FILE__), *%w[linked_in request.rb])
end

