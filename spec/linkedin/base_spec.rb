require File.dirname(__FILE__) + '/../spec_helper.rb'

describe LinkedIn::Base, 'when doing CRUD' do  
  before do 
    oauth = LinkedIn::OAuth.new('token', 'secret')
    @access_token = OAuth::AccessToken.new(oauth.consumer, 'atoken', 'asecret')
    oauth.stub!(:access_token => @access_token)
    @linkedin = LinkedIn::Base.new(oauth)    
  end
  
  context "initialize" do
    it "should require a client" do
      @linkedin.client.should respond_to(:get)
      @linkedin.client.should respond_to(:post)
    end
    
    it "should delegate get to the client" do
      @access_token.should_receive(:get).with('/foo').and_return(nil)
      @linkedin.get('/foo')
    end

    it "should delegate post to the client" do
      @access_token.should_receive(:post).with('/foo', {:bar => 'baz'}).and_return(nil)
      @linkedin.post('/foo', {:bar => 'baz'})
    end    
  end
    
  context "getting profiles" do
    it "should get basic profile" do
      stub_get('/v1/people/~', 'profile.xml')
      profile = @linkedin.profile
      profile['first-name'].should == 'Peter'
      profile['last-name'].should == 'Brown'
      profile['site-standard-profile-request'].url.should == 'http://www.linkedin.com/profile?viewProfile=&amp;key=280094&amp;authToken=GkV9&amp;authType=name'
    end

    it "should get full profile " do
      stub_get('/v1/people/~:full', 'profile.xml')
      profile = @linkedin.profile(:full)
      profile['first-name'].should == 'Peter'
      # need more checks for FULL profile, whatever that means
    end
    
    it "should default to ~ (authenticated users profile)" do
      @linkedin.should_receive(:perform_get).with('/v1/people/~', :query => {}).and_return(nil)
      profile = @linkedin.profile      
    end
    
    it "should get public profile from URL" do
      stub_get('/v1/people/url=http://www.linkedin.com/pub/peter-brown/0/116/112', 'profile.xml')
      profile = @linkedin.profile(:url => 'http://www.linkedin.com/pub/peter-brown/0/116/112')
      profile['first-name'].should == 'Peter'
    end    
    
    it "should get public profile from ID" do
      stub_get('/v1/people/id=12345', 'profile.xml')
      profile = @linkedin.profile(:id => '12345')
      profile['first-name'].should == 'Peter'
    end        
  end  
  
  context "getting connections" do
    it "should get connections" do
      stub_get('/v1/people/~/connections', 'connections.xml')
      connections = @linkedin.connections
      connections['total'].should == '81' # attribute
      connections['person'].size.should == 2 # array of people      
      connections['person'][0]['first-name'].should == 'John'
    end    
    
    it "should get connections with query params" do
      stub_get('/v1/people/~/connections?count=20&start=0', 'connections.xml')
      connections = @linkedin.connections(nil, nil, :start => 0, :count => 20)
      connections['person'][0]['first-name'].should == 'John'
    end
    
    it "should get connections with field selectors" do
      stub_get('/v1/people/~/connections:(id,first-name)', 'connections_with_field_selectors.xml')
      connections = @linkedin.connections(['id', 'first-name'])
      connections['person'][0]['first-name'].should == 'Jeff'
    end    
  end
    
  context "getting people" do
    it "should get people" do
      stub_get('/v1/people', 'people.xml')
      people = @linkedin.people
      people['total'].should == '46441' # attribute
      people['person'].size.should == 2
    end
  end
  
  context "getting network updates" do
    it "should get full network update" do
      stub_get('/v1/people/~/network', 'network.xml')
      network = @linkedin.network
      network['network-stats'].size.should == 2
    end

    it "should include stat properties" do
      stub_get('/v1/people/~/network', 'network.xml')
      network = @linkedin.network
      network['network-stats']['property'].size.should == 2
    end
    
    it "should include first ten update details" do
      stub_get('/v1/people/~/network', 'network.xml')
      network = @linkedin.network
      network['updates']['update'].size.should == 2
    end    
    
    it "should get with query params" do
      stub_get('/v1/people/~/network?count=20&start=0', 'network.xml')
      network = @linkedin.network(:start => 0, :count => 20)      
    end
  end
  
  context 'posting network activity updates' do
    it 'should post an update' do
      stub_post('/v1/people/~/person-activities', 'empty.xml')
      activities = @linkedin.person_activities('some update')
    end
  end
  
  context 'putting current status updates' do
    it 'should put current status update' do
      stub_put('/v1/people/~/current-status', 'empty.xml')
      @linkedin.current_status('some update')
    end
  end
  
end