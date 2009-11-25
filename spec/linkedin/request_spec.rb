require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Linkedin::Request, 'when getting requests' do
  before do
    @client = mock('twitter client')
    @request = Linkedin::Request.new(@client, :get, '/statuses/user_timeline.json', {:query => {:since_id => 1234}})
  end
    
  it "should have client" do
    @request.client.should == @client
  end
  
  it "should have method" do
    @request.method.should == :get
  end
  
  it "should have path" do
    @request.path.should == '/statuses/user_timeline.json'
  end
  
  it "should have options" do
    @request.options[:query].should == {:since_id => 1234}
  end
  
  it "should have uri" do
    @request.uri.should == '/statuses/user_timeline.json?since_id=1234'
  end
end

describe Linkedin::Request, 'when putting requests' do 
  before do
    @client = mock('twitter client')
    @request = Linkedin::Request.new(@client, :put, '/statuses/user_timeline.json', {:body => '<some>xml</some>'})
  end
    
  it "should have client" do
    @request.client.should == @client
  end
  
  it "should have method" do
    @request.method.should == :put
  end
  
  it "should have path" do
    @request.path.should == '/statuses/user_timeline.json'
  end
  
  it "should have options" do
    @request.options[:body].should == '<some>xml</some>'
  end
end

describe Linkedin::Request, 'when getting raising errors' do
  before do    
    oauth = Linkedin::OAuth.new('token', 'secret')
    oauth.authorize_from_access('atoken', 'asecret')
    @client = Linkedin::Base.new(oauth)    
  end

  it "should not raise error for 200" do
    stub_get('/foo', 'empty.xml', ['200'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should_not raise_error
  end
  
  it "should not raise error for 304" do
    stub_get('/foo', 'empty.xml', ['304'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should_not raise_error
  end
  
  it "should raise Unauthorized for 401" do
    stub_get('/foo', 'empty.xml', ['401'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should raise_error(Linkedin::Unauthorized)
  end
  
  it "should raise General for 403" do
    stub_get('/foo', 'empty.xml', ['403'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should raise_error(Linkedin::Forbidden)
  end
  
  it "should raise NotFound for 404" do
    stub_get('/foo', 'empty.xml', ['404'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should raise_error(Linkedin::NotFound)
  end
  
  it "should raise Unavailable for 500" do
    stub_get('/foo', 'empty.xml', ['500'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should raise_error(Linkedin::Unavailable)
  end
  
  it "should raise Unavailable for 502" do
    stub_get('/foo', 'empty.xml', ['502'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should raise_error(Linkedin::Unavailable)
  end
  
  it "should raise Unavailable for 503" do
    stub_get('/foo', 'empty.xml', ['503'])
    lambda {
      Linkedin::Request.get(@client, '/foo')
    }.should raise_error(Linkedin::Unavailable)
  end
end