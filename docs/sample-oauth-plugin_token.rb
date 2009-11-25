require 'linkedin'
require 'oauth/models/consumers/token'

class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token  
end

class LinkedinToken < ConsumerToken  
  def client
    unless @client
      @linkedin_oauth = Linkedin::OAuth.new(LinkedinToken.consumer.key, LinkedinToken.consumer.secret)
      @linkedin_oauth.authorize_from_access(token,secret)
      @client = Linkedin::Base.new(@linkedin_oauth)
    end
    
    @client
  end
end