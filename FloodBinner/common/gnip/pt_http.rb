# encoding: utf-8

# [] Replace with rest-client gem? https://github.com/rest-client/rest-client
# [] Following implementation useful as pseudo-code for other languages.

require 'logging'

#=======================================================================================================================
#A simple RESTful HTTP class put together for this Rehydration script.
#Future versions will most likely use an external PtREST object, common to all PowerTrack ruby clients.
class PtHTTP
    require "net/https"     #HTTP gem.
    require "uri"

    attr_accessor :url, :uri, :user_name, :password_encoded, :headers, :data,
                  :account_name, :publisher, :label, :timeout

    def initialize(url=nil, user_name=nil, password_encoded=nil, headers=nil)
        if not url.nil?
            @url = url
        end

        if not user_name.nil?
            @user_name = user_name
        end

        if not password_encoded.nil?
            @password_encoded = password_encoded
            @password = Base64.decode64(@password_encoded)
        end

        if not headers.nil?
            @headers = headers
        end
      
        @timeout = 60
    end

    def url=(value)
        @url = value
        @uri = URI.parse(@url)
    end

    def password_encoded=(value)
        @password_encoded=value
        if not @password_encoded.nil? then
            @password = Base64.decode64(@password_encoded)
        end
    end

    #---------------------------------------------------

    #Helper function for building URLs.

    #TODO: implement a method that has product passed in.
    def getURL(product,account_name=nil,label=nil)

    end

    def getRulesURL(account_name=nil,label=nil)
      @url = "https://api.gnip.com/accounts/"  #Root url for Search PowerTrack.

      if account_name.nil? then #using object account_name attribute.
        if @account_name.nil?
          p "No account name set.  Can not set url."
        else
          @url = @url + "#{@account_name}/publishers/#{@publisher}/streams/track/"
        end
      else #account_name passed in, so use that...
        @url = @url + "#{account_name}/publishers/#{@publisher}/streams/track/"
      end


      if label.nil? then #user not passing in anything...
        if @label.nil?
          p "No stream label (like 'prod' or 'dev') set.  Can not set url."
          return @url  #albeit incomplete.
        end
        @url = @url + "#{@label}/rules.json"
      else
        @url = @url + "#{label}/rules.json"
      end

      return @url
    end

    def getSearchCountURL(account_name=nil,label=nil)

        @url = "https://search.gnip.com/accounts/"  #Root url for Search PowerTrack.

        if account_name.nil? then #user not passing in anything...
            if @account_name.nil?
                p "No account name set.  Can not set url."
                return @url #albeit incomplete.
            end
            @url = @url + "#{@account_name}/search/"
        else
            @url = @url + "#{account_name}/search/"
        end


        if label.nil? then #user not passing in anything...
            if @label.nil?
                p "No stream label (like 'prod' or 'dev') set.  Can not set url."
                return @url  #albeit incomplete.
            end
            @url = @url + "#{@label}/counts.json"
        else
            @url = @url + "#{label}/counts.json"
        end

        return @url
    end

    #---------------------------------------------------

    #Fundamental REST API methods:
    def POST(data=nil)

        if not data.nil? #if request data passed in, use it.
            @data = data
        end

        uri = URI(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = @timeout
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.body = @data
        request.basic_auth(@user_name, @password)

        begin
            response = http.request(request)
        rescue
            sleep 2
            response = http.request(request) #try again
        end

        return response
    end

    def GET(params=nil,headers=nil)
        uri = URI(@url)

        #params are passed in as a hash.
        #Example: params["max"] = 100, params["since_date"] = 20130321000000
        if not params.nil?
            uri.query = URI.encode_www_form(params)
        end

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        if not headers.nil?

          headers.each do |key,value|
            request.add_field key, value
          end
        end

        request.basic_auth(@user_name, @password)

        begin
            response = http.request(request)
        rescue
            sleep 5
            response = http.request(request) #try again
        end

        return response
    end

end #PtREST class.

