class ActiveRecordClient

  attr_accessor :database_adapter, :db_host, :db_port, :schema, :db_username, :db_password,
                :sql, :time

  def get_database_config(config_file)

    config = YAML.load_file(config_file)

    @db_host = config["database"]["host"]
    @db_port = config["database"]["port"]
    @db_schema = config["database"]["schema"]
    @db_user_name = config["database"]["user_name"]
    @db_password = config["database"]["password"]
  end

  def establish_connection
    begin
      ActiveRecord::Base.establish_connection(
          :adapter => @database_adapter,
          :host => @db_host,
          :username => @db_user_name,
          :password => @db_password,
          :database => @db_schema,
          :pool => 20,
          :timeout => 10000
      )
    rescue
      p 'db error'
    end
  end

  def initialize(host=nil, port=nil, database=nil, user_name=nil, password=nil)

    #Create helper objects.
    #@time = TimeHelpers.new

    #local database for storing activity data...

    @sql = TweetSql.new

    @database_adapter = 'mysql' #current default.

    if host.nil? then
      @db_host = "127.0.0.1" #Local host is default.
    else
      @db_host = host
    end

    if port.nil? then
      @db_port = 3306 #MySQL port is default.
    else
      @db_port = port
    end

    if not user_name.nil? #No default for this setting.
      @db_username = user_name
    end

    if not password.nil? #No default for this setting.
      @db_password = password
    end

    if not database.nil? #No default for this setting.
      @db_schema = database
    end
  end
end