module Linkedin
  # >> oauth = Linkedin::OAuth.new('token', 'secret')
  # => #<Linkedin::OAuth:0x1021db048 ...> 
  # >> oauth.request_token.authorize_url 
  # => "https://api.linkedin.com/uas/oauth/authorize?oauth_token=XXXX" # goto URL
  # >> oauth.authorize_from_request(oauth.request_token.token, oauth.request_token.secret, PIN)
  # DONE    
  class OAuth    
    extend Forwardable
    
    SITE_URL = 'https://api.linkedin.com'
    
    def_delegators :access_token, :get, :post, :put
    
    attr_reader :ctoken, :csecret, :consumer_options
    
    # Options
    def initialize(ctoken, csecret, options={})
      @ctoken = ctoken
      @csecret = csecret
      @consumer_options = {
        :request_token_path => "/uas/oauth/requestToken?oauth_callback=oob",
        :access_token_path  => "/uas/oauth/accessToken",
        :authorize_path     => "/uas/oauth/authorize"
      }.merge(options)
    end
    
    def consumer
      @consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => SITE_URL}.merge(consumer_options))
    end
    
    def set_callback_url(url)
      clear_request_token
      request_token(:oauth_callback => url)
    end
    
    # Note: If using oauth with a web app, be sure to provide :oauth_callback.
    # Options:
    #   :oauth_callback => String, url that linkedin should redirect to
    def request_token(options={})
      @request_token ||= consumer.get_request_token(options)
    end
    
    # For web apps use params[:oauth_verifier], for desktop apps,
    # use the verifier is the pin that twitter gives users.
    def authorize_from_request(rtoken, rsecret, verifier_or_pin)
      request_token = ::OAuth::RequestToken.new(consumer, rtoken, rsecret)
      access_token = request_token.get_access_token(:oauth_verifier => verifier_or_pin)
      @atoken, @asecret = access_token.token, access_token.secret
    end
    
    def access_token
      @access_token ||= ::OAuth::AccessToken.new(consumer, @atoken, @asecret)
    end
    
    def authorize_from_access(atoken, asecret)
      @atoken, @asecret = atoken, asecret
    end
    
    private
      def clear_request_token
        @request_token = nil
      end
  end
end