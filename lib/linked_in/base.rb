module LinkedIn
  class Base
    API_VERSION = 'v1'
    extend Forwardable
    
    def_delegators :client, :get, :post, :put
    
    attr_reader :client
    
    def initialize(client)
      @client = client
    end
    
    # Lookup Options: url=<public profile URL>, id=<member id>
    # Field Options: :full
    def profile(fields = nil, lookup = nil, query = {})
      path = profile_path(nil, lookup, fields)
      perform_get(path, :query => query)
    end    
    
    # Query options: start=N, count=N
    def people(query = {})
      path = api_path('people')
      perform_get(path, query)
    end
    
    # Query options: start=N, count=N
    def connections(fields = nil, lookup = nil, query = {})
      path = profile_path('connections', lookup, fields)
      perform_get(path, :query => query)
    end
    
    def network(query = {})
      path = profile_path('network')
      perform_get(path, :query => query)
    end
    
    def current_status(update)
      path = profile_path('current-status')
      update_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><current-status>#{update}</current-status>"
      perform_put(path, :body => update_xml)
    end
    
    # update is something like: '&lt;a href=&quot;http://www.linkedin.com/profile?viewProfile=&amp;key=ABCDEFG&quot;&gt;Richard Brautigan&lt;/a&gt; is reading about&lt;a href=&quot;http://www.tigers.com&quot;&gt;Tigers&lt;/a&gt;http://www.tigers.com&gt;Tigers&lt;/a&gt;.'}
    def person_activities(update, timestamp = nil)
      path = profile_path('person-activities')
      body = {'activity' => {
        'timestamp' => (timestamp || Time.now.to_i),
        'content-type' => 'linkedin-html', 
        'body' => update}
      }
      perform_post(path, body)
    end
    
    
    private
    
    def api_path(p)
      "/#{API_VERSION}/#{p}"
    end
    
    def profile_path(api = nil, lookup = nil, fields = nil)
      path =  api_path('people') + '/'
      path += lookup.kind_of?(Hash) ? "#{lookup.first[0]}=#{lookup.first[1]}" : (lookup || '~')
      path += api.nil? ? '' : "/#{api}"
      path += fields.kind_of?(Array) ? ":(#{fields.collect{|f| f.to_s}.join(',')})" : ""
      path
    end

    def perform_get(path, options={})
      LinkedIn::Request.get(self, path, options)
    end
    
    def perform_post(path, options={})
      LinkedIn::Request.post(self, path, options)
    end

    def perform_put(path, options={})
      LinkedIn::Request.put(self, path, options)
    end
  
  end
end