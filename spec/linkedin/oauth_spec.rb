require File.dirname(__FILE__) + '/../spec_helper.rb'

describe LinkedIn::OAuth, 'when doing CRUD' do
  
  before do 
    @default_options = {:access_token_path=>"/uas/oauth/accessToken", :site=>"https://api.linkedin.com", 
      :authorize_path=>"/uas/oauth/authorize", :request_token_path=>"/uas/oauth/requestToken?oauth_callback=oob"}
  end
  
  it "should initialize with consumer token and secret" do
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    
    linkedin.ctoken.should == 'token'
    linkedin.csecret.should == 'secret'
  end
  
  it "shgould set autorization path to '/uas/oauth/authorize' by default" do
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    linkedin.consumer.options[:authorize_path].should == '/uas/oauth/authorize'
  end
  
  it "should have a consumer" do
    consumer = mock('oauth consumer')    
    OAuth::Consumer.should_receive(:new).with('token', 'secret', @default_options).and_return(consumer)
    linkedin = LinkedIn::OAuth.new('token', 'secret')    
    linkedin.consumer.should == consumer
  end
  
  it "should have a request token from the consumer" do
    consumer = mock('oauth consumer')
    request_token = mock('request token')
    consumer.should_receive(:get_request_token).and_return(request_token)
    OAuth::Consumer.should_receive(:new).with('token', 'secret', @default_options).and_return(consumer)
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    
    linkedin.request_token.should == request_token
  end  

  it "should clear request token and set the callback url" do
    consumer = mock('oauth consumer')
    request_token = mock('request token')
    
    OAuth::Consumer.
      should_receive(:new).
      with('token', 'secret', @default_options).
      and_return(consumer)
    
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    
    consumer.
      should_receive(:get_request_token).
      with({:oauth_callback => 'http://myapp.com/oauth_callback'})
    
    linkedin.set_callback_url('http://myapp.com/oauth_callback')
  end
  
  it "should be able to create access token from request token, request secret and verifier" do
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    consumer = OAuth::Consumer.new('token', 'secret', @default_options)
    linkedin.stub!(:consumer => consumer)
    
    access_token  = mock('access token', :token => 'atoken', :secret => 'asecret')
    request_token = mock('request token')
    request_token.
      should_receive(:get_access_token).
      with(:oauth_verifier => 'verifier').
      and_return(access_token)
      
    OAuth::RequestToken.
      should_receive(:new).
      with(consumer, 'rtoken', 'rsecret').
      and_return(request_token)
    
    linkedin.authorize_from_request('rtoken', 'rsecret', 'verifier')
    linkedin.access_token.class.should be(OAuth::AccessToken)
    linkedin.access_token.token.should == 'atoken'
    linkedin.access_token.secret.should == 'asecret'
  end
  
  it "should create access token from access token and secret" do
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    consumer = OAuth::Consumer.new('token', 'secret', @default_options)
    linkedin.stub!(:consumer => consumer)
    
    linkedin.authorize_from_access('atoken', 'asecret')
    linkedin.access_token.class.should be(OAuth::AccessToken)
    linkedin.access_token.token.should == 'atoken'
    linkedin.access_token.secret.should == 'asecret'
  end
  
  it "should delegate get to access token" do
    access_token = mock('access token')
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    linkedin.stub!(:access_token => access_token)
    access_token.should_receive(:get).and_return(nil)
    linkedin.get('/foo')
  end
  
  it "should delegate post to access token" do
    access_token = mock('access token')
    linkedin = LinkedIn::OAuth.new('token', 'secret')
    linkedin.stub!(:access_token => access_token)
    access_token.should_receive(:post).and_return(nil)
    linkedin.post('/foo')
  end
end
