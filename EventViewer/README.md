
# EventViewer

Prototype of a general 'event viewer' for events that have unfolded on Twitter.

First use-case is the 2013 Colorado Flood.

Consists of:
+ Display 'layer' being prototypes at https://github.com/blehman/maperator
+ Display is based on JSON dataset produced by FloodBinner
  + JSON dataset consists of several features:  
    + Time-series of geo JSON tweet.
    + Metadata around the Twitter event.    
    + Time-series of 'very important' tweets
    + Optional time-series of 'external' geo-tagged data.
      + Example: rain and stage data from 2013 Colorado Flood.   
    + Metadata of 'external' data - site locations.
