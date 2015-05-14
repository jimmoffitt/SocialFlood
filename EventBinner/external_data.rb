#-----------------------------------------------------------------------------------------------------------------------
# External metadata is geotagged. (timeseries data is not, but tied to a geotagged site)
#
# {} stats
# {} weather
#     {} stage
#         .type: FeatureCollection
#         [] features
#             {}0
#                .type "Feature"
#                {} geometry
#                     .type
#                     [] coordinates
#                         .0 long
#                         .1 lat
#                {] properties
#                     .site_id
#                     .name
#                     .altitude
#     {} rain
# {} time_series
#      {} metadata
#      {} interval_data
#

require 'active_record'
require_relative './common/time_helpers.rb'
require_relative './database/hydro_sql.rb'

class Site < ActiveRecord::Base
  validates_uniqueness_of :site_id
end

class Rainvalue < ActiveRecord::Base
end

class Stagevalue < ActiveRecord::Base
end



class HydroData

  attr_accessor :sql, :rain_site_list, :stage_site_list
  
  def initialize
    @sql = HydroSQL.new
    @rain_site_list = '1110,4050,4070,4170,4220,4240,4360,4550,4830,4870'
    @stage_site_list = '10017,10018,10021,4830,4390,4870,4430,4410,4580,4590'
  end
  

  def get_sites(site_list)

    rs_sites = Site.connection.select_all(@sql.get_sites_sql(site_list))

    sites = []

    rs_sites.each do |row|
      site = {}
      row.each do |key,value|
        site[key] = value
      end
      sites << site
    end

    sites
  end

  def getGeoJSON(data)
    data = {}
    data["site_id"] = 1520
    data["stage"] = 12.5
    data["rain_incr"] = 0.04
    data["rain_accum"] = 5.44
    data["long"] = -105.4
    data["lat"] = 39

    #Let's make some GeoJSON...
    geometry = {"type" => "Point", "coordinate" => [data["long"], data["lat"]]}
    properties = {"site_id" => data["site_id"], "rain_incr" => data["rain_incr"], "rain_accum" => tweet["rain_accum"]}
    geoTweet = {"type" => "Feature", "geometry" => geometry, "properties" => properties}

  end

  def get_geo_json_site(site)
    site_geo = {}
    site_geo['type'] = "Feature"

    #Add geo metadata.
    site_geo['geometry'] = {}
    site_geo['geometry']['type'] = "Point"
    site_geo['geometry']['coordinates'] = []

    #Handle Twitter Places by doing some math when needed.
    site_geo['geometry']['coordinates'] << site['long']
    site_geo['geometry']['coordinates'] << site['lat']

    site_geo['properties'] = {}
    site_geo['properties']['name'] = clean_site_name(site['name'])
    site_geo['properties']['site_id'] = site['site_id']
    site_geo['properties']['altitude'] = site['altitude'] unless site['altitude'].nil?

    site_geo

  end
  
  def clean_site_name(name)
    name.downcase.gsub(/\s/,'_')
  end
  
  
  
  def get_metadata
    
    sites_metadata = {}
    
    rain_sites = get_sites(@rain_site_list)
    rain_sites.each do |row|
 
      #Add the 'rain' attribute, creating key if necessary.
      if not sites_metadata.key?('rain') then
        sites_metadata['rain'] = {}
        sites_metadata['rain']['type'] = "FeatureCollection"
        sites_metadata['rain']['features'] = [] #Array of geoJSON tweets.
      end

      #Assemble this geoJSON tweet.
      site_geo = {}
      site_geo = get_geo_json_site(row)

      #Add to current interval tweet array.
      sites_metadata['rain']['features'] << site_geo
    end
    
    
    stage_sites = get_sites(@stage_site_list)
    stage_sites.each do |row|

      #Add the 'rain' attribute, creating key if necessary.
      if not sites_metadata.key?('stage') then
        sites_metadata['stage'] = {}
        sites_metadata['stage']['type'] = "FeatureCollection"
        sites_metadata['stage']['features'] = [] #Array of geoJSON tweets.
      end

      #Assemble this geoJSON tweet.
      site_geo = {}
      site_geo = get_geo_json_site(row)

      #Add to current interval tweet array.
      sites_metadata['stage']['features'] << site_geo
    end
    
    #puts sites_metadata
    
    sites_metadata

  end

#-----------------------------------------------------------------------------------------------------------------------
# Timeseries data is not geotagged, but is tied to a geotagged site.
#
# {}interval_data 
#   {} 2013-09-11 20:00:00
#     {} tweet_geo
#     {} tweet_vit
#     {} stats
#     {} weather
#          {} rain
#              {} accum
#              {} incr
#          {} stage 


  def get_timeseries(params)

    oTime = TimeHelpers.new
    
    #Start building 'interval_data' hash.
    interval_data = {}

    #Get rain time-series data.
    rain_data = Rainvalue.connection.select_all(@sql.get_rain_data_sql(@rain_site_list, params))
    rain_data.each do |row|
      #puts "increment: #{row['incr_15']} | accumulation: #{row['accum_event']}"

      this_interval_key = oTime.get_interval(row['posted_at'], params[:interval], 'end')
      
      #Add interval key if necessary. 
      if not interval_data.key?(this_interval_key) then
        interval_data[this_interval_key] = {}
      end

      if not interval_data[this_interval_key].key?('rain') then
        interval_data[this_interval_key]['rain'] = {}
      end

      #Add rain site name to hash
      if not interval_data[this_interval_key]['rain'].key?(clean_site_name(row['name'])) then
        interval_data[this_interval_key]['rain'][clean_site_name(row['name'])] = {}
      end

      #Event accumulation.
      interval_data[this_interval_key]['rain'][clean_site_name(row['name'])]['accumulation'] = row['accum_event'].to_f

      #Add rain values
      #Hourly increment.
      #puts "row: #{row['incr_15']}"
      #puts "hash: #{interval_data[this_interval_key]['rain'][clean_site_name(row['name')]]['increment'].to_f}"
      
      interval_accum = 0
      interval_accum = interval_data[this_interval_key]['rain'][clean_site_name(row['name'])]['increment'].to_f unless interval_data[this_interval_key]['rain'][clean_site_name(row['name'])]['increment'].nil?

      interval_data[this_interval_key]['rain'][clean_site_name(row['name'])]['increment'] = row['incr_15'].to_f + interval_accum

    end


    #Get stage time-series data.
    stage_data = Stagevalue.connection.select_all(@sql.get_stage_data_sql(@stage_site_list, params))
    stage_data.each do |row|
      #puts "stage: #{row['avg_15']} "

      this_interval_key = oTime.get_interval(row['posted_at'], params[:interval], 'end')

      #Add interval key if necessary. 
      if not interval_data.key?(this_interval_key) then
        interval_data[this_interval_key] = {}
      end

      if not interval_data[this_interval_key].key?('stage') then
        interval_data[this_interval_key]['stage'] = {}
      end

      #Add stage site name to hash
      if not interval_data[this_interval_key]['stage'].key?(clean_site_name(row['name'])) then
        interval_data[this_interval_key]['stage'][clean_site_name(row['name'])] = {}
      end

      #TODO: this is not quite right. Should take average of 4 avg_15 values.
      #Stage.
      interval_data[this_interval_key]['stage'][clean_site_name(row['name'])]['stage'] = row['avg_15'].to_f
    end

    interval_data
    
  end
  
  def establish_connection
    oDS = ActiveRecordClient.new
    oDS.get_database_config('./config/config_private.yaml')
    oDS.establish_connection
  end
  
  
end

#==============================
if __FILE__ == $0  #This script code is executed when running this file.


end