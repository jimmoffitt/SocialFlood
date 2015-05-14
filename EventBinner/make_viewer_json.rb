#POC project for pulling database tweets and generating various output, such as:
#   * time-series CSV files with Twitter metadata... various counts per interval, like hashtags.
#   * time-series of JSON/geoJSON objects.

#Currently, this code gets MySQL data directly...
require 'active_record'
require 'yaml'
require 'csv'
require 'json'

require_relative './hydro_data.rb'
require_relative './common/time_helpers.rb'
require_relative './database/tweet_sql.rb'
require_relative './database/active_record_client.rb'

class Activity < ActiveRecord::Base
  validates_uniqueness_of :tweet_id, :id
end

=begin
  {tweets: {
    "type": "FeatureCollection",
    "features": [ geoTweet, geoTweet ]
    }
  }
=end

#TODO: combine these GeoJSON methods

def getGeoJSON(tweet)
  #Let's make some GeoJSON...
  geometry = {"type" => "Point", "coordinate" => [tweet["long"], tweet["lat"]]}
  properties = {"body" => tweet["body"], "link" => tweet["link"], "tweet" => tweet["tweet"]}
  geoTweet = {"type" => "Feature", "geometry" => geometry, "properties" => properties}
end

def get_coordinates(tweet)

  coordinates = []
  
  #Handle Twitter Places by doing some math when needed.
  if tweet['long_box'].nil? then #Geotagged with Exact Location (Point).
    coordinates << tweet['long']
    coordinates << tweet['lat']
  else #We have a Twitter Place.
    coordinates << (tweet['long'].to_f + tweet['long_box'].to_f) / 2
    coordinates << (tweet['lat'].to_f + tweet['lat_box'].to_f) / 2
  end
  
  coordinates

end

def getGeoJSONTweet(tweet,specifyGeoType)
    tweet_geo = {}
    tweet_geo['type'] = "Feature"
    
    #Add geo metadata.
    tweet_geo['geometry'] = {}
    tweet_geo['geometry']['type'] = "Point"
    tweet_geo['geometry']['coordinates'] = []

    tweet_geo['geometery']['coordinates'] = get_coordinates(tweet)

    tweet_geo['properties'] = {}
    tweet_geo['properties']['tweet_url'] = tweet['link']

    tweet_geo['properties']['geo_type'] = 'tweet_geo' unless !specifyGeoType

    if !tweet['urls'].nil? then

      tweet_geo['properties']['media'] = [] #media is an array since there can be multiple links/photos/etc.
      medias = tweet['urls'].split(',')
      medias.each do |media|
        tweet_geo['properties']['media'] << media
      end
    end

    tweet_geo
end

def getJSONTweet(tweet,specifyGeoType)
  tweet_geo = {}

  #Add geo metadata.
  tweet_geo['coordinates'] = get_coordinates(tweet)

  tweet_geo['tweet_url'] = tweet['link']
  
  tweet_geo['geo_type'] = 'tweet_geo' unless !specifyGeoType

  if !tweet['urls'].nil? then

    tweet_geo['media'] = [] #media is an array since there can be multiple links/photos/etc.
    medias = tweet['urls'].split(',')
    medias.each do |media|
      tweet_geo['media'] << media
    end
  end

  tweet_geo
end

def getGeoJSONTweetProfile(tweet, specifyGeoType)

  #Assemble this geoJSON tweet.
  tweet_profile = {}
  tweet_profile['type'] = "Feature"

  #Add geo metadata.
  tweet_profile['geometry'] = {}
  tweet_profile['geometry']['type'] = "Point"
  tweet_profile['geometry']['coordinates'] = get_coordinates(tweet)

  tweet_profile['properties'] = {}
  tweet_profile['properties']['tweet_url'] = tweet['link']
  
  tweet_profile['properties']['geo_type'] = 'profile_geo' unless !specifyGeoType

  if !tweet['urls'].nil? then
    tweet_profile['properties']['media'] = [] #media is an array since there can be multiple links/photos/etc.
    medias = tweet['urls'].split(',')
    medias.each do |media|
      tweet_profile['properties']['media'] << media
    end
  end
  
  tweet_profile
end

def getJSONTweetProfile(tweet, specifyGeoType)

  #Assemble this geoJSON tweet.
  tweet_profile = {}

  #Add geo metadata.
  tweet_profile['coordinates'] = get_coordinates(tweet)

  tweet_profile['tweet_url'] = tweet['link']
  
  tweet_profile['geo_type'] = 'profile_geo' unless !specifyGeoType

  if !tweet['urls'].nil? then
    tweet_profile['media'] = [] #media is an array since there can be multiple links/photos/etc.
    medias = tweet['urls'].split(',')
    medias.each do |media|
      tweet_profile['media'] << media
    end
  end

  tweet_profile

end

def add_geo_data(interval_data, rs_tweets, key_name, interval, make_geo_json, combine_geo)

  oTime = TimeHelpers.new

  rs_tweets.each do |row|
    this_interval_key = oTime.get_interval(row['posted_at'], interval, 'end')

    if not interval_data.key?(this_interval_key) then
      interval_data[this_interval_key] = {}
    end

    #Add the 'tweets_geo' attribute, creating key if necessary.
    if not interval_data[this_interval_key].key?(key_name) then
      if make_geo_json then
        interval_data[this_interval_key][key_name] = {}
        interval_data[this_interval_key][key_name]['type'] = "FeatureCollection"
        interval_data[this_interval_key][key_name]['features'] = [] #Array of geoJSON tweets.
      else
        interval_data[this_interval_key][key_name] = []
      end
    end

    #Assemble this geoJSON tweet.
    tweet_geo = {}

    if make_geo_json then
      tweet_geo = getGeoJSONTweet(row, combine_geo)
      #Add to current interval tweet array.
      interval_data[this_interval_key][key_name]['features'] << tweet_geo
    else
      tweet_geo = getJSONTweet(row, combine_geo)
      interval_data[this_interval_key][key_name] << tweet_geo
    end
  end
end

def add_non_geo_data(interval_data, rs_tweets, key_name, interval)

  oTime = TimeHelpers.new

  rs_tweets.each do |row|
    this_interval_key = oTime.get_interval(row['posted_at'], interval, 'end')

    if not interval_data.key?(this_interval_key) then
      interval_data[this_interval_key] = {}
    end

    #Add the 'tweets' attribute, creating key if necessary.
    if not interval_data[this_interval_key].key?(key_name) then
      interval_data[this_interval_key][key_name] = []
    end

    tweet = {}

    #Add geo metadata.
    tweet['tweet_url'] = row['link']

    if !row['urls'].nil? then
      tweet['media'] = [] #media is an array since there can be multiple links/photos/etc.
      medias = row['urls'].split(',')
      medias.each do |media|
        tweet['media'] << media
      end
    end
    
    interval_data[this_interval_key][key_name] << tweet
  end
end

def add_interval_stats(interval_data, key_name, make_geo_json)
  #Tour the geoJSON features array and gather some stats.
  interval_data.each do |key, value|
    if not value.key?('stats') then
      value['stats'] = {}
    end

    tweets_num = 0

    #tweets_geo_with_media
    if !value[key_name].nil? then
      if make_geo_json then
        tweets_num = value[key_name]['features'].length
      else
        tweets_num = value[key_name].length
      end
      value['stats'][key_name] = tweets_num
    end
  end
end

def add_hashtags_stats(data_set, interval_data, rs_tweets, hashtag, interval)

  oTime = TimeHelpers.new

  interval_previous = ''
  hashtag_count = 0

  #Add global hashtag stats count.
  if not data_set['stats'].key?('hashtags') then
    data_set['stats']['hashtags'] = {}
  end

  data_set['stats']['hashtags'][hashtag] = rs_tweets.rows.length

  rs_tweets.each do |row|

    this_interval_key = oTime.get_interval(row['posted_at'], interval, 'end')

    if this_interval_key != interval_previous then
      hashtag_count = 0
    end

    if not interval_data.key?(this_interval_key) then
      interval_data[this_interval_key] = {}
    end

    #Add the 'stats:hashtags' attribute, creating key if necessary.
    if not interval_data[this_interval_key].key?('stats') then
      interval_data[this_interval_key]['stats'] = {}
    end

    #Add the 'stats:hashtags' attribute, creating key if necessary.
    if not interval_data[this_interval_key]['stats'].key?('hashtags') then
      interval_data[this_interval_key]['stats']['hashtags'] = {}
    end

    hashtag_count = hashtag_count + 1
    interval_data[this_interval_key]['stats']['hashtags'][hashtag] = hashtag_count

    interval_previous = this_interval_key
  end
end





#==============================
if __FILE__ == $0 #This script code is executed when running this file.

  #Create an instance of SQL helper
  oSQL = TweetSql.new
  oTime = TimeHelpers.new

  #Make a database connection.
  oDS = ActiveRecordClient.new
  oDS.get_database_config('./config/config_private.yaml')
  oDS.establish_connection

  #-------------------------------------------------------------------------------------------------------------------
  #TODO: get via either the CL or config file. 
  params = {}
  params[:start_date] = "2013-09-11 00:00:00"
  params[:end_date] = "2013-09-18 00:00:00"
  params[:interval] = 60 #minutes

  #Profile Geo parameters.
  params[:region] = 'Colorado'
  params[:profile_west] = -105.6336
  params[:profile_east] = -104.2608
  params[:profile_south] = 39.68
  params[:profile_north] = 40.6275

  include_non_twitter_data = true
  include_hashtag_stats = true
  make_geo_json = false
  combine_profile_and_activity_geos = false
  #-------------------------------------------------------------------------------------------------------------------

  #OK, now generating a JSON data set for the event.
  data_set = {} #the Mother lode --> data_set.to_json

  #-------------------------------------------------------------------------------------------------------------------
  #TODO: --> external_metadata = {} 
  external_metadata = {}
  external_timeseries = {}
  if include_non_twitter_data then
    external = HydroData.new
    external.establish_connection
    external_metadata = external.get_metadata()
    data_set['hydro_sites'] = external_metadata

    external_timeseries = external.get_timeseries(params)
  end

  #-------------------------------------------------------------------------------------------------------------------

  #Time-series data -------------------------------
  time_series = {}

  time_metadata = {}
  time_metadata['time_start'] = params[:start_date]
  time_metadata['time_end'] = params[:end_date]
  time_metadata['interval_minutes'] = params[:interval]
  time_metadata['time_format'] = 'YYYY-MM-DD HH:mm:ss'
  time_metadata['tz'] = 'UTC'
  time_metadata['tz_offset'] = 0 #minutes

  time_series['metadata'] = time_metadata

  #Getting tweets, which is not already binned into intervals.
  #Need to walk through selected tweets and add to time-series dataset.

  #Getting any stats?
  data_set['stats'] = {}

  rs_tweets = Activity.connection.select_all(oSQL.get_tweets_count(params))
  data_set['stats']['tweets'] = rs_tweets.rows[0][0].to_f

  #Interval time-series data, a completely different animal.
  interval_data = external_timeseries
  
  #-------------------------------------------------------------------------------------------------------------------
  #Getting geo-tagged tweets WITH MEDIA
  #------------------------------------
  key_name = 'geo_taggged_with_media'
  rs_tweets = Activity.connection.select_all(oSQL.get_geo_tagged_tweets_with_media(params))
  data_set['stats'][key_name] = rs_tweets.rows.length #Global stats.

  add_geo_data(interval_data, rs_tweets, key_name, params[:interval], make_geo_json, combine_profile_and_activity_geos)
  add_interval_stats(interval_data,key_name, make_geo_json)

  #-------------------------------------------------------------------------------------------------------------------
  #Getting geo-tagged tweets WITHOUT MEDIA
  #---------------------------------------
  key_name = 'geo_taggged_without_media'
  rs_tweets = Activity.connection.select_all(oSQL.get_geo_tagged_tweets_without_media(params))
  data_set['stats'][key_name] = rs_tweets.rows.length #Global stats.
  
  add_geo_data(interval_data, rs_tweets, key_name, params[:interval], make_geo_json, combine_profile_and_activity_geos)
  add_interval_stats(interval_data,key_name, make_geo_json)

  #-------------------------------------------------------------------------------------------------------------------
  #Grab Profile Geo Tweets that are NOT geo-tagged (for those are already included above).
  #-------------------------------------------

  key_name = ''
  if combine_profile_and_activity_geos then
    key_name = 'tweets_geo_with_media'
  else
    key_name = 'tweets_profile_with_media'
  end
  
  rs_tweets = Activity.connection.select_all(oSQL.get_tweets_with_media_profile_geo_only_by_bounding_box(params))
  data_set['stats'][key_name] = rs_tweets.rows.length #Global stats.

  add_geo_data(interval_data, rs_tweets, key_name, params[:interval], make_geo_json, combine_profile_and_activity_geos)
  add_interval_stats(interval_data,key_name, make_geo_json)

  #-------------------------------------------------------------------------------------------------------------------
  #Getting non-geo-tagged VIT tweets, because geo-tagged ones are included above.
  #---------------------------------
  key_name = 'tweets_vit'
  rs_tweets = Activity.connection.select_all(oSQL.get_non_geo_vit_tweets(params))
  data_set['stats'][key_name] = rs_tweets.rows.length #Global stats.

  add_non_geo_data(interval_data, rs_tweets, key_name, params[:interval])
  add_interval_stats(interval_data,key_name, false)

  #-------------------------------------------------------------------------------------------------------------------
  #Hashtag stats.  These are stats only... Tweets with these hashtags are not explicitly in dataset.
  #So, not building interval array of these Tweets, rather just compiling numbers.
  #-------------------------------------------------------------------------------

  if include_hashtag_stats then

    hashtag = "*flood"
    rs_tweets = Activity.connection.select_all(oSQL.get_tweets_with_hashtag(params, hashtag))
    add_hashtags_stats(data_set, interval_data, rs_tweets, hashtag, params[:interval])

    hashtag = "boulderflood"
    rs_tweets = Activity.connection.select_all(oSQL.get_tweets_with_hashtag(params, hashtag))
    add_hashtags_stats(data_set, interval_data, rs_tweets, hashtag, params[:interval])

    hashtag = "coloradoflood|coflood" #SQL code handles these '|' OR clauses.
    rs_tweets = Activity.connection.select_all(oSQL.get_tweets_with_hashtag(params, hashtag))
    add_hashtags_stats(data_set, interval_data, rs_tweets, hashtag, params[:interval])

    hashtag = "longmontflood"
    rs_tweets = Activity.connection.select_all(oSQL.get_tweets_with_hashtag(params, hashtag))
    add_hashtags_stats(data_set, interval_data, rs_tweets, hashtag, params[:interval])

  end

  #---------------------------------------------------------------------------------------------------------------------
  #Special case here where we are pulling a time-series of counts via SQL,
  #and then populate 'stats' key with counts.

  rs_counts = Activity.connection.select_all(oSQL.get_tweet_count_timeseries(params))

  rs_counts.each do |row|
    #this_interval_key = oTime.get_interval(row['timeslice'], params[:interval], 'end')
    this_interval_key = row['timeslice'].to_s.split('UTC')[0].strip!

    if not interval_data.key?(this_interval_key) then
      interval_data[this_interval_key] = {}
    end

    #Add the 'stats' attribute, creating key if necessary.
    if not interval_data[this_interval_key].key?('stats') then
      interval_data[this_interval_key]['stats'] = {}
      
    end

    interval_data[this_interval_key]['stats']['tweets'] = row['tweets'].to_f

  end

  #-------------------------------------------------------------------------------------------------------------------

  #Assemble final data_set hash.
  time_series['interval_data'] = interval_data
  data_set['time_series'] = time_series

  # This will change the encoding and remove weird characters
  data_set_fixed = data_set.to_s.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_')

  #Write JSON to a file
  filename = "event_viewer.json"
  f = File.new(filename, "w+")
  f.puts data_set.to_json

  #f.puts data_set.to_json.to_s.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_')
  f.close

  #Create stage sites hash.
  puts 'done!'
end

