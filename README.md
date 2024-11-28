SocialFlood
===========

This is a snapshot of some passion project back many years ago, not long after the historic Colorado Flood in 2013. 

I had posted a series of blog posts that focused on two professional interests: early warning systems and the Twitter developer platform. The posts started with a discussion of looking for rainfall 'signals' in Twitter data, then discussed potential roles the Twitter network could play in early-warning systems, and finally wrapped up with how the 2013 Colorado Flood unfolded on Twitter...
 
The data analysis behind these blog posts included a variety of software tools that helped harvest both Twitter and meteorological data, [store that data in a MySQL database](http://support.gnip.com/articles/relational-databases-part-1.html), and then perform the time-series analysis presented.

These tools fell out of this project:

+ [EventBinner](https://github.com/jimmoffitt/SocialFlood/tree/master/EventBinner): Ruby code that pulls data from MySQL and outputs event (Geo)JSON data.  Combines Twitter and 'external' data into an integrated source file for project viewers. 
+ [EventViewer](https://github.com/jimmoffitt/SocialFlood/tree/master/EventViewer): Web map-based event viewer. Source 'maperator' project lives here: https://github.com/blehman/maperator
+ [EventPlots](https://github.com/jimmoffitt/SocialFlood/tree/master/EventPlots): prototype for building d3 time-series plots of event.
+ [EventDeck](https://github.com/jimmoffitt/SocialFlood/tree/master/EventDeck): Receives streamed data and displays Tweets in pre-defined columns, ala TweetDeck.

### EventViewer with EventPlots
![](https://raw.githubusercontent.com/jimmoffitt/SocialFlood/master/imgs/SocialFlood.png)

### EventDeck

 ![](https://raw.githubusercontent.com/jimmoffitt/SocialFlood/master/EventDeck/imgs/flood_event_deck.png)






