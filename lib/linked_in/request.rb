module LinkedIn
  class Request
     extend Forwardable
    
    def self.get(client, path, options = {})
      new(client, :get, path, options).perform
    end
    
    def self.post(client, path, options = {})
      new(client, :post, path, options).perform
    end
    
    def self.put(client, path, options = {})
      new(client, :put, path, options).perform
    end
    
    attr_reader :client, :method, :path, :options
    
    def_delegators :client, :get, :post, :put
    
    def initialize(client, method, path, options={})
      @client, @method, @path, @options = client, method, path, {:mash => true}.merge(options)
    end
    
    def uri
      @uri ||= begin
        uri = URI.parse(path)
        
        if options[:query] && options[:query] != {}
          uri.query = to_query(options[:query])
        end
        
        uri.to_s
      end
    end
    
    def perform
      make_friendly(send("perform_#{method}"))
    end
    
    private
      def perform_get
        send(:get, uri, options[:headers])
      end
      
      def perform_post
        send(:post, uri, options[:body], options[:headers])
      end
      
      def perform_put
        send(:put, uri, options[:body], options[:headers])
      end
      
      def make_friendly(response)
        raise_errors(response)
        parse(response)        
      end
            
      def raise_errors(response)
        case response.code.to_i
        when 401 # NotAuthorized
          raise Unauthorized.new, "#{response.code}: #{response.message}"
        when 403 # Forbidden
          raise Forbidden.new, "#{response.code}: #{response.message}"
        when 404 # NotFound
          raise NotFound, "#{response.code}: #{response.message}"
        when 500 # InternalServerError
          raise Unavailable, "LinkedIn had an internal error #{response.code}: #{response.message}"
        when 502..503 # Unavailable, BadGateway
          raise Unavailable, "#{response.code}: #{response.message}"
        end
      end
      
      def parse(response)
        return if response.nil? || response.body.blank?
        XMLObject.new(response.body)
      end
      
      def to_query(options)
        options.inject([]) do |collection, opt| 
          collection << "#{opt[0]}=#{opt[1]}"
          collection
        end * '&'
      end
  end
end