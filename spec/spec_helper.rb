begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'linkedin'
require 'fakeweb'

FakeWeb.allow_net_connect = false

def linkedin_url(path)
  "https://api.linkedin.com#{path}"
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:get, linkedin_url(url), options)
end

def stub_post(url, filename)
  FakeWeb.register_uri(:post, linkedin_url(url), :body => fixture_file(filename))
end

def stub_put(url, filename)
  FakeWeb.register_uri(:put, linkedin_url(url), :body => fixture_file(filename))
end
