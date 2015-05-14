# EventBinner

#### TO-DOs
+ Output updates: 
  + option to wipe tweet bodies. 
  + site names with no punctuation.

### Overview

* Generates (Geo)JSON data for a general 'event viewer' prototype for multi-day events that have unfolded on Twitter.
* First use-case is the 2013 Colorado Flood.

* Geo Display 'layer' being prototyped at https://github.com/blehman/maperator (and forked here: )
 
* Configured to export 7 days of data from Flood database:
  + External data:
    + Site metadata: 10 rain sites and 10 river-level sites.
    + Hourly rain and stage data for those sites.
    + No stats. 
  + Twitter data:
    + Geo-tagged Tweets with Media.
    + Stats:
      + Event tweet and hashtag counts.
      + Time-series of tweets and hashtag counts.

### Example JSON Schema
** Subject to change**

![](https://raw.githubusercontent.com/jimmoffitt/SocialFlood/master/FloodBinner/docs/exampleSchema.png)


### "External Data" details.
+ For this first use case the external data is rain and river-level (stage) data from multiple locations, binned to hourly values.
+ Source rain and stage data is in 15-minute increments, and source event data is available).

+ Rain values are hourly accumulations
+ River-levels are hourly maximums (averages are available in current db, but not in current code). 


### Configuration details

```
#JSON Dataset options:
event_viewer:
  include_twitter_data: true
  include_hashtag_stats: true
  include_external_data: true

external_data:
  alias: hydro
  rain_site_list: 1110,4050,4070,4170,4220,4240,4360,4550,4830,4870
  stage_site_list: 10017,10018,10021,4830,4390,4870,4430,4410,4580,4590

event_details:
  start_date: 2013-09-11 00:00:00
  end_date: 2013-09-18 00:00:00
  interval: 60 #minutes

  #Profile Geo parameters.
  profile_region: Colorado
  profile_west: -105.6336
  profile_east: -104.2608
  profile_south: 39.68
  profile_north: 40.6275
 
  #Tweet Geo parameters.
  tweet_west: -105.6336
  tweet_east: -104.2608
  tweet_south: 39.68
  tweet_north: 40.6275

database:
  type: mysql
  host: localhost
  port: 3306
  #Note: currently all PowerTrack example clients share a common database schema.
  schema: flood_development
  user_name: 
  password_encoded:
```



