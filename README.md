SocialFlood
===========
A collection of things related to display and analysis around the 2013 Colorado Flood.

I posted a series of blog posts that focued on two professional interests: early warning systems and Twitter data.

The research behind these blog posts involved a variety of software tools that helped harvest both Twitter and meteorlogical data, [store that data in a MySQL database](http://support.gnip.com/articles/relational-databases-part-1.html), and then perform the time-series analysis presented in the posts:

- https://blog.gnip.com/tweeting-in-the-rain/
- https://blog.gnip.com/tweeting-in-the-rain-part-2/
- https://blog.gnip.com/tweeting-in-the-rain-part-3/
- https://blog.gnip.com/tweeting-rain-part-4-tweets-2013-colorado-flood/
 
So far these tools have fallen out of this effort:

+ EventBinner: Ruby code that pulls data from MySQL and outputs event (Geo)JSON data.  Combines Twitter and 'external' data into an integrated source file for project viewers. 
+ EventViewer: Web map-based event viewer. Source 'maperator' project lives here: https://github.com/blehman/maperator
+ EventPlots: prototype for building d3 time-series plots of event.

![](https://raw.githubusercontent.com/jimmoffitt/SocialFlood/master/EventViewer/imgs/EventTools.png)




#### Background

I have a big interest in flood warning systems and lots of expereince developing meteorology/hydrology-monitoring software. [This](https://www.onerain.com/solutions/diadvisor) was something I focused on for over ten years... I helped build data services that drive [this family of web-based early-warning systems](https://www.onerain.com/contrail-hydrologic-software). Those services focuses on a API for data and metadata exchange, based on a family of Java Servlets. Also developed back-end Java apps that provided alarm and notification services.



