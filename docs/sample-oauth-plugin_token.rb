require 'linked_in'
require 'oauth/models/consumers/token'

class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token  
end

class LinkedInToken < ConsumerToken  
  def client
    unless @client
      @linkedin_oauth = LinkedIn::OAuth.new(LinkedInToken.consumer.key, LinkedInToken.consumer.secret)
      @linkedin_oauth.authorize_from_access(token,secret)
      @client = LinkedIn::Base.new(@linkedin_oauth)
    end
    
    @client
  end
end