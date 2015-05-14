## EventBinner

### Overview

* Generates (Geo)JSON data for a general 'event viewer' prototype for multi-day events that have unfolded on Twitter.
* First use-case is the 2013 Colorado Flood.

* Bins Tweet and External data into a common dataset with three root keys/hives:
  * 'external_metadata': stores metadata of external dataset, such as site name and geo location. 
  * 'stats': Tweet stats, such as number in source data
  * 'time-series': time-series keys with 'YYYY-MM-DD HH:MM' format, each having an 'interval' value.

        ![](https://github.com/jimmoffitt/SocialFlood/blob/master/EventBinner/docs/event_viewer_dataset_root_keys.png)
    

* Root/Global 'stats' payload: 
 * ![](https://github.com/jimmoffitt/SocialFlood/blob/master/EventBinner/docs/event_viewer_dataset_global_stats.png)  

* 'time-series' payload:
 * ![](https://github.com/jimmoffitt/SocialFlood/blob/master/EventBinner/docs/event_viewer_dataset_time_series.png)   
 
* 'interval-data' payload:
 * ![](https://github.com/jimmoffitt/SocialFlood/blob/master/EventBinner/docs/event_viewer_dataset_time_series.png)   


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

#### Recent updates
+ Data binning SQL was updated to support any time-series interval. 
+ New option to produce non-GeoJSON-based dataset (maperator does not currently need GeoJSON format).
+ New option to combine or separate 'tweets_geo' tweets. Current EventViewer focus is on "geo-tagged" Tweets with Media. Geo-tagged can mean either Tweet Geo or Profile Geo. 
  + If this option is set to 'true', all geo-tagged Tweets are written to a common interval key of 'tweets_geo' and every Tweet in that interval's array has a 'geo-type' attribute that indicates the type of source geo.   
  + If 'false', there are separate interval keys: 'tweet_geo_with_media'
     
+ External data site names with spaces/punctuation are transformed to JSON friendly keys.

#### Current To-dos:
+ Add JSON/GeoJSON option to 'external' data?


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

### Database Schema Details

Activities table:
```
CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(20) DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `verb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `repost_of_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `lang` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `generator` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mentions` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urls` text COLLATE utf8_unicode_ci,
  `media` text COLLATE utf8_unicode_ci,
  `place` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `long` float(11,6) DEFAULT NULL,
  `lat` float(11,6) DEFAULT NULL,
  `long_box` float(11,6) DEFAULT NULL,
  `lat_box` float(11,6) DEFAULT NULL,
  `followers_count` int(11) DEFAULT NULL,
  `friends_count` int(11) DEFAULT NULL,
  `statuses_count` int(11) DEFAULT NULL,
  `klout_score` int(11) DEFAULT NULL,
  `payload` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `vit` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tweet_id` (`tweet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=573597 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
```

Actor table:
```
CREATE TABLE `actors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `actor_link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bio` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lang` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `time_zone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `utc_offset` int(11) DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile_geo_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile_geo_long` float DEFAULT NULL,
  `profile_geo_lat` float DEFAULT NULL,
  `profile_geo_country_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile_geo_region` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile_geo_subregion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile_geo_locality` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=113874 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
```

Hashtag table:

```
CREATE TABLE `hashtags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(20) DEFAULT NULL,
  `hashtag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tweet_id` (`tweet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=509453 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
```


### External Data Schema

Site metadata:

```
CREATE TABLE `sites` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `site_id` int(11) NOT NULL,
  `lat` double NOT NULL,
  `long` double NOT NULL,
  `altitude` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
```

Rain data values:

```
CREATE TABLE `rainvalues` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `posted_at` datetime NOT NULL,
  `site_id` int(11) unsigned NOT NULL,
  `sensor_id` int(11) unsigned DEFAULT NULL,
  `incr_15` float DEFAULT NULL,
  `accum` float DEFAULT NULL,
  `accum_event` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103681 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
```

Stage values:

```
CREATE TABLE `stagevalues` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `posted_at` datetime DEFAULT NULL,
  `site_id` int(11) unsigned NOT NULL,
  `sensor_id` int(11) unsigned DEFAULT NULL,
  `max_15` float DEFAULT NULL,
  `avg_15` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51841 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
```








