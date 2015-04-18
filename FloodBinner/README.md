
# FloodBinner

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
+ River-levels are hourly maximums (averages are available 

