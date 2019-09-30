# Generating a collection of Hurricane Harvey Tweets 

Building filters/rules/queries for generating a collection of Tweets that help tell the story of how Hurricane Harvey unfolded on Twitter.  

These rules are used with Twitter APIs to match and collect Tweets. These Tweets are currently loaded into a relational database. Reviewing database contents provides a second pass at Tweet collection curation (e.g. deleting Tweets that do not help tell the story). From the database, Tweet IDs (along with some supporting metadata such as available geographic coordinates) are then written to a JSON-based data resource used by the data visualization tool.

Building a rule set to match on Harvey Tweets is an iterative process. The rules below represent a first version and these will evolve as the collection is curated.

### Rule fundamentals

The "match Tweet" operators below are fundamental for surfacing Tweets of interest. 
* Keywords | A set of words and phrases that characterize the Tweet as one of interest.
* #hashtags | A set of hashtags related to the event of interest. 
* -is:retweet | In most cases we are interested only in original Tweets. We can rehydrate Tweet is sharing metadata is needed.
* is:verified | A set of 'official' accounts that we want all Tweets from. 
* has:media | Native media (photos and videos).
* Media hosted elsewhere | Photos and videos hosted elsewhere like Google Photos and Instagram. 
* has:geo | Geo-tagged Tweet. 
* has:profile_geo | Tweet from an account with a 'home' location that can be geo-referenced to at least country level.
  * profile_region:texas | Tweet from an account with a 'home' location of Texas, USA. 
  
Geo-tagged Tweets with photos and videos are the 'special sauce' for event visualization. These Tweets illustrate the powerful and actionable content that Twitter provides during these types of events.
  
  
### Identifying Tweets identified by user as about Hurricane Harvey

The following set of keywords and hashtags are the initial set used to surface Tweets of interest. 

(harvey OR hurricane OR #HarveySOS OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey OR #HelpHouston OR #Flood OR #HarveyRescue OR @HarveyRescue)
  
## Verified accounts of interest

### Weather
+ @NWSNHC
+ @NWSHouston
+ @NWSSanAntonio
+ @JeffLindner1 
+ (Add hurricane forecasts)

### Operations, public comms
+ @HoustonOEM
+ @ReadyHarris 
+ @HoustonFire 
+ @HCSOTexas
+ @HoustonTX
+ @BrazoriaCounty 
+ (Others from the public safety sector)
+ Other Texas counties to add: Matagorda, Calhoun, Refugio, Galveston, Fort Bend, Wharton, Chambers, Liberty, Montgomery, Colorado, Waller, Grimes, Washington, Cameron, Willacy, Kennedy

## Other data
+ @USGS_TexasRain, rainfall
+ @USGS_TexasFlood, stage
+ (Other forecast and modeling sources?)

### Media
+ @HoustonChron
+ @DallesNews
+ @HoustonPress 
+ @LakeHoustonNews 
+ @ExpressNews 
+ @HoustonPubMedia 
+ @ktrhnews 
+ @abc13weather 
+ @KHOU
+ (Others)

## Example rules: 

### Partners and cooperators

Counties to add: Matagorda, Calhoun, Refugio, Galveston, Fort Bend, Wharton, Chambers, Liberty, Montgomery, Colorado, Waller, Grimes, Washington, Cameron, Willacy, Kennedy

```json
 {"value" : "-is:retweet (from:HoustonOEM OR from:ReadyHarris OR from:HoustonFire OR from:HoustonTX OR from:BrazoriaCounty OR from:HCSOTexas OR @USGS_Texas OR @FEMARegion6)",
  "tag" : "partners, operations, public safety, public communication, originial posts"
 }
```

### Weather and meteorology 

For Texas, this includes real-time rain and river level data.

```json
 {"value" : "-is:retweet (from:NWSNHC OR from:NWSHouston OR from:NWSSanAntonio OR from:USGS_TexasRain OR from:USGS_TexasRain OR from:JeffLindner1)",
  "tag" : "meteorologic, originial posts"
 }
```

### Media

```json
 {"value" : "-is:retweet (from:HoustonChron OR from:DallesNews OR from:HoustonPress OR from:LakeHoustonNews OR from:ExpressNews OR from:HoustonPubMedia OR from:ktrhnews OR from:abc13weather OR from:KHOU)",
  "tag" : "verified, originial posts"
 }
``` 

### Geo-tagged 'harvey' Tweets with media

```json
 {"value" : "-is:retweet has:media has:geo (harvey OR hurricane OR #HarveySOS OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey OR #HelpHouston OR #Flood OR #HarveyRescue OR @HarveyRescue)",
  "tag" : "geo, media" 
 } 
```

### Profile-geo-tagged 'harvey' Tweets with media

```json
 {"value" : "-is:retweet has:media profile_region:texas -has:geo (harvey OR hurricane OR #HarveySOS OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey OR #HelpHouston OR #Flood OR #HarveyRescue OR @HarveyRescue)",
  "tag" : "profile-geo, media"
 }
```

### Media hosted elsewhere, geo tagged

```json
{"value" : "-is:retweet profile_region:texas has:geo (url:instagram OR url:\"photos.google\") (harvey OR hurricane OR #HarveySOS OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey OR #HelpHouston OR #Flood OR #HarveyRescue OR @HarveyRescue)",
                "tag" : "harvey-mention, linked media, Texas profile, geo-tagged"
 }
 ```
 
 
 
## JSON array of rules.

Putting it all together. 



The following ruleset was generated during hackweek.

```json



```


The following ruleset was used for the initial prep-for-hackweek data pull. 

```json
{
	"rules": [{
			"value": "-is:retweet (from:HoustonOEM OR from:ReadyHarris OR from:HoustonFire OR from:HoustonTX OR from:BrazoriaCounty OR from:HCSOTexas OR @USGS_Texas OR from:FEMARegion6 OR from:HarveyRescue)",
			"tag": "partners, operations, public safety, public communication, originial posts"
		},
		{
			"value": "-is:retweet (from:NWSNHC OR from:NWSHouston OR from:NWSSanAntonio OR from:USGS_TexasRain OR from:USGS_TexasRain OR from:JeffLindner1)",
			"tag": "meteorologic, original posts"
		},
		{
			"value": "-is:retweet (from:HoustonChron OR from:DallesNews OR from:HoustonPress OR from:LakeHoustonNews OR from:ExpressNews OR from:HoustonPubMedia OR from:ktrhnews OR from:abc13weather OR from:KHOU)",
			"tag": "verified, original posts"
		},
		{
			"value": "-is:retweet has:media has:geo (harvey OR hurricane OR #HarveySOS OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey OR #HelpHouston OR #Flood OR #HarveyRescue OR @HarveyRescue)",
			"tag": "geo, media"
		}, {
			"value": "-is:retweet has:media profile_region:texas -has:geo (harvey OR hurricane OR #HarveySOS OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey OR #HelpHouston OR #Flood OR #HarveyRescue OR @HarveyRescue)",
			"tag": "profile-geo, media"
		},
		{
			"value": "-is:retweet profile_region:texas has:geo (url:instagram OR url:\"photos.google\") (harvey OR hurricane OR #HarveySOS OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey OR #HelpHouston OR #Flood OR #HarveyRescue OR @HarveyRescue)",
			"tag": "harvey-mention, linked media, Texas profile, geo-tagged"

		}
	]
}
```
 
 
 
 ## Other rules (currently not used)
 
 These seem a bit too general....
 
 ```json
 ,
            {
                "value" : "has:media -is:retweet profile_region:Texas (flood OR rain OR storm OR emergency)",
                "tag" : "flood help"
            },
            {
                "value" : "-is:retweet profile_region:Texas (rescue OR ((need OR send) help) OR ((house OR street OR neighborhood) ((under water) OR flooded)) OR (this address) OR (on roof))",
                "tag" : "rescus, flood help"
            }
 
 ```
 
 


## Geo bounding boxes

These are not used yet. Generated with https://github.com/jimmoffitt/bounding-boxes.

/bounding-boxes/rbBoundingBoxes -w -99 -e -89.5 -n 32 -s 24.25 -d  -b 180

Expecting 728 boxes (26 rows X 28 columns).

### Large box with 43 rules

These rules are a set of 

```csv
{rule clauses} (bounding_box:[-99.00000 24.25000 -98.65000 24.55000] OR bounding_box:[-98.65000 24.25000 -98.30000 24.55000] OR bounding_box:[-98.30000 24.25000 -97.95000 24.55000] OR bounding_box:[-97.95000 24.25000 -97.60000 24.55000] OR bounding_box:[-97.60000 24.25000 -97.25000 24.55000] OR bounding_box:[-97.25000 24.25000 -96.90000 24.55000] OR bounding_box:[-96.90000 24.25000 -96.55000 24.55000] OR bounding_box:[-96.55000 24.25000 -96.20000 24.55000] OR bounding_box:[-96.20000 24.25000 -95.85000 24.55000] OR bounding_box:[-95.85000 24.25000 -95.50000 24.55000] OR bounding_box:[-95.50000 24.25000 -95.15000 24.55000] OR bounding_box:[-95.15000 24.25000 -94.80000 24.55000] OR bounding_box:[-94.80000 24.25000 -94.45000 24.55000] OR bounding_box:[-94.45000 24.25000 -94.10000 24.55000] OR bounding_box:[-94.10000 24.25000 -93.75000 24.55000])
{rule clauses} (bounding_box:[-93.75000 24.25000 -93.40000 24.55000] OR bounding_box:[-93.40000 24.25000 -93.05000 24.55000] OR bounding_box:[-93.05000 24.25000 -92.70000 24.55000] OR bounding_box:[-92.70000 24.25000 -92.35000 24.55000] OR bounding_box:[-92.35000 24.25000 -92.00000 24.55000] OR bounding_box:[-92.00000 24.25000 -91.65000 24.55000] OR bounding_box:[-91.65000 24.25000 -91.30000 24.55000] OR bounding_box:[-91.30000 24.25000 -90.95000 24.55000] OR bounding_box:[-90.95000 24.25000 -90.60000 24.55000] OR bounding_box:[-90.60000 24.25000 -90.25000 24.55000] OR bounding_box:[-90.25000 24.25000 -89.90000 24.55000] OR bounding_box:[-89.90000 24.25000 -89.55000 24.55000] OR bounding_box:[-89.55000 24.25000 -89.50000 24.55000] OR bounding_box:[-99.00000 24.55000 -98.61940 24.85000] OR bounding_box:[-98.61940 24.55000 -98.23880 24.85000])
{rule clauses} (bounding_box:[-98.23880 24.55000 -97.85820 24.85000] OR bounding_box:[-97.85820 24.55000 -97.47760 24.85000] OR bounding_box:[-97.47760 24.55000 -97.09700 24.85000] OR bounding_box:[-97.09700 24.55000 -96.71640 24.85000] OR bounding_box:[-96.71640 24.55000 -96.33580 24.85000] OR bounding_box:[-96.33580 24.55000 -95.95520 24.85000] OR bounding_box:[-95.95520 24.55000 -95.57460 24.85000] OR bounding_box:[-95.57460 24.55000 -95.19400 24.85000] OR bounding_box:[-95.19400 24.55000 -94.81340 24.85000] OR bounding_box:[-94.81340 24.55000 -94.43280 24.85000] OR bounding_box:[-94.43280 24.55000 -94.05220 24.85000] OR bounding_box:[-94.05220 24.55000 -93.67160 24.85000] OR bounding_box:[-93.67160 24.55000 -93.29100 24.85000] OR bounding_box:[-93.29100 24.55000 -92.91040 24.85000] OR bounding_box:[-92.91040 24.55000 -92.52980 24.85000])
{rule clauses} (bounding_box:[-92.52980 24.55000 -92.14920 24.85000] OR bounding_box:[-92.14920 24.55000 -91.76860 24.85000] OR bounding_box:[-91.76860 24.55000 -91.38800 24.85000] OR bounding_box:[-91.38800 24.55000 -91.00740 24.85000] OR bounding_box:[-91.00740 24.55000 -90.62680 24.85000] OR bounding_box:[-90.62680 24.55000 -90.24620 24.85000] OR bounding_box:[-90.24620 24.55000 -89.86560 24.85000] OR bounding_box:[-89.86560 24.55000 -89.50000 24.85000] OR bounding_box:[-99.00000 24.85000 -98.61850 25.15000] OR bounding_box:[-98.61850 24.85000 -98.23700 25.15000] OR bounding_box:[-98.23700 24.85000 -97.85550 25.15000] OR bounding_box:[-97.85550 24.85000 -97.47400 25.15000] OR bounding_box:[-97.47400 24.85000 -97.09250 25.15000] OR bounding_box:[-97.09250 24.85000 -96.71100 25.15000] OR bounding_box:[-96.71100 24.85000 -96.32950 25.15000])
{rule clauses} (bounding_box:[-96.32950 24.85000 -95.94800 25.15000] OR bounding_box:[-95.94800 24.85000 -95.56650 25.15000] OR bounding_box:[-95.56650 24.85000 -95.18500 25.15000] OR bounding_box:[-95.18500 24.85000 -94.80350 25.15000] OR bounding_box:[-94.80350 24.85000 -94.42200 25.15000] OR bounding_box:[-94.42200 24.85000 -94.04050 25.15000] OR bounding_box:[-94.04050 24.85000 -93.65900 25.15000] OR bounding_box:[-93.65900 24.85000 -93.27750 25.15000] OR bounding_box:[-93.27750 24.85000 -92.89600 25.15000] OR bounding_box:[-92.89600 24.85000 -92.51450 25.15000] OR bounding_box:[-92.51450 24.85000 -92.13300 25.15000] OR bounding_box:[-92.13300 24.85000 -91.75150 25.15000] OR bounding_box:[-91.75150 24.85000 -91.37000 25.15000] OR bounding_box:[-91.37000 24.85000 -90.98850 25.15000] OR bounding_box:[-90.98850 24.85000 -90.60700 25.15000])
{rule clauses} (bounding_box:[-90.60700 24.85000 -90.22550 25.15000] OR bounding_box:[-90.22550 24.85000 -89.84400 25.15000] OR bounding_box:[-89.84400 24.85000 -89.50000 25.15000] OR bounding_box:[-99.00000 25.15000 -98.61760 25.45000] OR bounding_box:[-98.61760 25.15000 -98.23520 25.45000] OR bounding_box:[-98.23520 25.15000 -97.85280 25.45000] OR bounding_box:[-97.85280 25.15000 -97.47040 25.45000] OR bounding_box:[-97.47040 25.15000 -97.08800 25.45000] OR bounding_box:[-97.08800 25.15000 -96.70560 25.45000] OR bounding_box:[-96.70560 25.15000 -96.32320 25.45000] OR bounding_box:[-96.32320 25.15000 -95.94080 25.45000] OR bounding_box:[-95.94080 25.15000 -95.55840 25.45000] OR bounding_box:[-95.55840 25.15000 -95.17600 25.45000] OR bounding_box:[-95.17600 25.15000 -94.79360 25.45000] OR bounding_box:[-94.79360 25.15000 -94.41120 25.45000])
{rule clauses} (bounding_box:[-94.41120 25.15000 -94.02880 25.45000] OR bounding_box:[-94.02880 25.15000 -93.64640 25.45000] OR bounding_box:[-93.64640 25.15000 -93.26400 25.45000] OR bounding_box:[-93.26400 25.15000 -92.88160 25.45000] OR bounding_box:[-92.88160 25.15000 -92.49920 25.45000] OR bounding_box:[-92.49920 25.15000 -92.11680 25.45000] OR bounding_box:[-92.11680 25.15000 -91.73440 25.45000] OR bounding_box:[-91.73440 25.15000 -91.35200 25.45000] OR bounding_box:[-91.35200 25.15000 -90.96960 25.45000] OR bounding_box:[-90.96960 25.15000 -90.58720 25.45000] OR bounding_box:[-90.58720 25.15000 -90.20480 25.45000] OR bounding_box:[-90.20480 25.15000 -89.82240 25.45000] OR bounding_box:[-89.82240 25.15000 -89.50000 25.45000] OR bounding_box:[-99.00000 25.45000 -98.61660 25.75000] OR bounding_box:[-98.61660 25.45000 -98.23320 25.75000])
{rule clauses} (bounding_box:[-98.23320 25.45000 -97.84980 25.75000] OR bounding_box:[-97.84980 25.45000 -97.46640 25.75000] OR bounding_box:[-97.46640 25.45000 -97.08300 25.75000] OR bounding_box:[-97.08300 25.45000 -96.69960 25.75000] OR bounding_box:[-96.69960 25.45000 -96.31620 25.75000] OR bounding_box:[-96.31620 25.45000 -95.93280 25.75000] OR bounding_box:[-95.93280 25.45000 -95.54940 25.75000] OR bounding_box:[-95.54940 25.45000 -95.16600 25.75000] OR bounding_box:[-95.16600 25.45000 -94.78260 25.75000] OR bounding_box:[-94.78260 25.45000 -94.39920 25.75000] OR bounding_box:[-94.39920 25.45000 -94.01580 25.75000] OR bounding_box:[-94.01580 25.45000 -93.63240 25.75000] OR bounding_box:[-93.63240 25.45000 -93.24900 25.75000] OR bounding_box:[-93.24900 25.45000 -92.86560 25.75000] OR bounding_box:[-92.86560 25.45000 -92.48220 25.75000])
{rule clauses} (bounding_box:[-92.48220 25.45000 -92.09880 25.75000] OR bounding_box:[-92.09880 25.45000 -91.71540 25.75000] OR bounding_box:[-91.71540 25.45000 -91.33200 25.75000] OR bounding_box:[-91.33200 25.45000 -90.94860 25.75000] OR bounding_box:[-90.94860 25.45000 -90.56520 25.75000] OR bounding_box:[-90.56520 25.45000 -90.18180 25.75000] OR bounding_box:[-90.18180 25.45000 -89.79840 25.75000] OR bounding_box:[-89.79840 25.45000 -89.50000 25.75000] OR bounding_box:[-99.00000 25.75000 -98.61570 26.05000] OR bounding_box:[-98.61570 25.75000 -98.23140 26.05000] OR bounding_box:[-98.23140 25.75000 -97.84710 26.05000] OR bounding_box:[-97.84710 25.75000 -97.46280 26.05000] OR bounding_box:[-97.46280 25.75000 -97.07850 26.05000] OR bounding_box:[-97.07850 25.75000 -96.69420 26.05000] OR bounding_box:[-96.69420 25.75000 -96.30990 26.05000])
{rule clauses} (bounding_box:[-96.30990 25.75000 -95.92560 26.05000] OR bounding_box:[-95.92560 25.75000 -95.54130 26.05000] OR bounding_box:[-95.54130 25.75000 -95.15700 26.05000] OR bounding_box:[-95.15700 25.75000 -94.77270 26.05000] OR bounding_box:[-94.77270 25.75000 -94.38840 26.05000] OR bounding_box:[-94.38840 25.75000 -94.00410 26.05000] OR bounding_box:[-94.00410 25.75000 -93.61980 26.05000] OR bounding_box:[-93.61980 25.75000 -93.23550 26.05000] OR bounding_box:[-93.23550 25.75000 -92.85120 26.05000] OR bounding_box:[-92.85120 25.75000 -92.46690 26.05000] OR bounding_box:[-92.46690 25.75000 -92.08260 26.05000] OR bounding_box:[-92.08260 25.75000 -91.69830 26.05000] OR bounding_box:[-91.69830 25.75000 -91.31400 26.05000] OR bounding_box:[-91.31400 25.75000 -90.92970 26.05000] OR bounding_box:[-90.92970 25.75000 -90.54540 26.05000])
{rule clauses} (bounding_box:[-90.54540 25.75000 -90.16110 26.05000] OR bounding_box:[-90.16110 25.75000 -89.77680 26.05000] OR bounding_box:[-89.77680 25.75000 -89.50000 26.05000] OR bounding_box:[-99.00000 26.05000 -98.61470 26.35000] OR bounding_box:[-98.61470 26.05000 -98.22940 26.35000] OR bounding_box:[-98.22940 26.05000 -97.84410 26.35000] OR bounding_box:[-97.84410 26.05000 -97.45880 26.35000] OR bounding_box:[-97.45880 26.05000 -97.07350 26.35000] OR bounding_box:[-97.07350 26.05000 -96.68820 26.35000] OR bounding_box:[-96.68820 26.05000 -96.30290 26.35000] OR bounding_box:[-96.30290 26.05000 -95.91760 26.35000] OR bounding_box:[-95.91760 26.05000 -95.53230 26.35000] OR bounding_box:[-95.53230 26.05000 -95.14700 26.35000] OR bounding_box:[-95.14700 26.05000 -94.76170 26.35000] OR bounding_box:[-94.76170 26.05000 -94.37640 26.35000])
{rule clauses} (bounding_box:[-94.37640 26.05000 -93.99110 26.35000] OR bounding_box:[-93.99110 26.05000 -93.60580 26.35000] OR bounding_box:[-93.60580 26.05000 -93.22050 26.35000] OR bounding_box:[-93.22050 26.05000 -92.83520 26.35000] OR bounding_box:[-92.83520 26.05000 -92.44990 26.35000] OR bounding_box:[-92.44990 26.05000 -92.06460 26.35000] OR bounding_box:[-92.06460 26.05000 -91.67930 26.35000] OR bounding_box:[-91.67930 26.05000 -91.29400 26.35000] OR bounding_box:[-91.29400 26.05000 -90.90870 26.35000] OR bounding_box:[-90.90870 26.05000 -90.52340 26.35000] OR bounding_box:[-90.52340 26.05000 -90.13810 26.35000] OR bounding_box:[-90.13810 26.05000 -89.75280 26.35000] OR bounding_box:[-89.75280 26.05000 -89.50000 26.35000] OR bounding_box:[-99.00000 26.35000 -98.61370 26.65000] OR bounding_box:[-98.61370 26.35000 -98.22740 26.65000])
{rule clauses} (bounding_box:[-98.22740 26.35000 -97.84110 26.65000] OR bounding_box:[-97.84110 26.35000 -97.45480 26.65000] OR bounding_box:[-97.45480 26.35000 -97.06850 26.65000] OR bounding_box:[-97.06850 26.35000 -96.68220 26.65000] OR bounding_box:[-96.68220 26.35000 -96.29590 26.65000] OR bounding_box:[-96.29590 26.35000 -95.90960 26.65000] OR bounding_box:[-95.90960 26.35000 -95.52330 26.65000] OR bounding_box:[-95.52330 26.35000 -95.13700 26.65000] OR bounding_box:[-95.13700 26.35000 -94.75070 26.65000] OR bounding_box:[-94.75070 26.35000 -94.36440 26.65000] OR bounding_box:[-94.36440 26.35000 -93.97810 26.65000] OR bounding_box:[-93.97810 26.35000 -93.59180 26.65000] OR bounding_box:[-93.59180 26.35000 -93.20550 26.65000] OR bounding_box:[-93.20550 26.35000 -92.81920 26.65000] OR bounding_box:[-92.81920 26.35000 -92.43290 26.65000])
{rule clauses} (bounding_box:[-92.43290 26.35000 -92.04660 26.65000] OR bounding_box:[-92.04660 26.35000 -91.66030 26.65000] OR bounding_box:[-91.66030 26.35000 -91.27400 26.65000] OR bounding_box:[-91.27400 26.35000 -90.88770 26.65000] OR bounding_box:[-90.88770 26.35000 -90.50140 26.65000] OR bounding_box:[-90.50140 26.35000 -90.11510 26.65000] OR bounding_box:[-90.11510 26.35000 -89.72880 26.65000] OR bounding_box:[-89.72880 26.35000 -89.50000 26.65000] OR bounding_box:[-99.00000 26.65000 -98.61280 26.95000] OR bounding_box:[-98.61280 26.65000 -98.22560 26.95000] OR bounding_box:[-98.22560 26.65000 -97.83840 26.95000] OR bounding_box:[-97.83840 26.65000 -97.45120 26.95000] OR bounding_box:[-97.45120 26.65000 -97.06400 26.95000] OR bounding_box:[-97.06400 26.65000 -96.67680 26.95000] OR bounding_box:[-96.67680 26.65000 -96.28960 26.95000])
{rule clauses} (bounding_box:[-96.28960 26.65000 -95.90240 26.95000] OR bounding_box:[-95.90240 26.65000 -95.51520 26.95000] OR bounding_box:[-95.51520 26.65000 -95.12800 26.95000] OR bounding_box:[-95.12800 26.65000 -94.74080 26.95000] OR bounding_box:[-94.74080 26.65000 -94.35360 26.95000] OR bounding_box:[-94.35360 26.65000 -93.96640 26.95000] OR bounding_box:[-93.96640 26.65000 -93.57920 26.95000] OR bounding_box:[-93.57920 26.65000 -93.19200 26.95000] OR bounding_box:[-93.19200 26.65000 -92.80480 26.95000] OR bounding_box:[-92.80480 26.65000 -92.41760 26.95000] OR bounding_box:[-92.41760 26.65000 -92.03040 26.95000] OR bounding_box:[-92.03040 26.65000 -91.64320 26.95000] OR bounding_box:[-91.64320 26.65000 -91.25600 26.95000] OR bounding_box:[-91.25600 26.65000 -90.86880 26.95000] OR bounding_box:[-90.86880 26.65000 -90.48160 26.95000])
{rule clauses} (bounding_box:[-90.48160 26.65000 -90.09440 26.95000] OR bounding_box:[-90.09440 26.65000 -89.70720 26.95000] OR bounding_box:[-89.70720 26.65000 -89.50000 26.95000] OR bounding_box:[-99.00000 26.95000 -98.61170 27.25000] OR bounding_box:[-98.61170 26.95000 -98.22340 27.25000] OR bounding_box:[-98.22340 26.95000 -97.83510 27.25000] OR bounding_box:[-97.83510 26.95000 -97.44680 27.25000] OR bounding_box:[-97.44680 26.95000 -97.05850 27.25000] OR bounding_box:[-97.05850 26.95000 -96.67020 27.25000] OR bounding_box:[-96.67020 26.95000 -96.28190 27.25000] OR bounding_box:[-96.28190 26.95000 -95.89360 27.25000] OR bounding_box:[-95.89360 26.95000 -95.50530 27.25000] OR bounding_box:[-95.50530 26.95000 -95.11700 27.25000] OR bounding_box:[-95.11700 26.95000 -94.72870 27.25000] OR bounding_box:[-94.72870 26.95000 -94.34040 27.25000])
{rule clauses} (bounding_box:[-94.34040 26.95000 -93.95210 27.25000] OR bounding_box:[-93.95210 26.95000 -93.56380 27.25000] OR bounding_box:[-93.56380 26.95000 -93.17550 27.25000] OR bounding_box:[-93.17550 26.95000 -92.78720 27.25000] OR bounding_box:[-92.78720 26.95000 -92.39890 27.25000] OR bounding_box:[-92.39890 26.95000 -92.01060 27.25000] OR bounding_box:[-92.01060 26.95000 -91.62230 27.25000] OR bounding_box:[-91.62230 26.95000 -91.23400 27.25000] OR bounding_box:[-91.23400 26.95000 -90.84570 27.25000] OR bounding_box:[-90.84570 26.95000 -90.45740 27.25000] OR bounding_box:[-90.45740 26.95000 -90.06910 27.25000] OR bounding_box:[-90.06910 26.95000 -89.68080 27.25000] OR bounding_box:[-89.68080 26.95000 -89.50000 27.25000] OR bounding_box:[-99.00000 27.25000 -98.61070 27.55000] OR bounding_box:[-98.61070 27.25000 -98.22140 27.55000])
{rule clauses} (bounding_box:[-98.22140 27.25000 -97.83210 27.55000] OR bounding_box:[-97.83210 27.25000 -97.44280 27.55000] OR bounding_box:[-97.44280 27.25000 -97.05350 27.55000] OR bounding_box:[-97.05350 27.25000 -96.66420 27.55000] OR bounding_box:[-96.66420 27.25000 -96.27490 27.55000] OR bounding_box:[-96.27490 27.25000 -95.88560 27.55000] OR bounding_box:[-95.88560 27.25000 -95.49630 27.55000] OR bounding_box:[-95.49630 27.25000 -95.10700 27.55000] OR bounding_box:[-95.10700 27.25000 -94.71770 27.55000] OR bounding_box:[-94.71770 27.25000 -94.32840 27.55000] OR bounding_box:[-94.32840 27.25000 -93.93910 27.55000] OR bounding_box:[-93.93910 27.25000 -93.54980 27.55000] OR bounding_box:[-93.54980 27.25000 -93.16050 27.55000] OR bounding_box:[-93.16050 27.25000 -92.77120 27.55000] OR bounding_box:[-92.77120 27.25000 -92.38190 27.55000])
{rule clauses} (bounding_box:[-92.38190 27.25000 -91.99260 27.55000] OR bounding_box:[-91.99260 27.25000 -91.60330 27.55000] OR bounding_box:[-91.60330 27.25000 -91.21400 27.55000] OR bounding_box:[-91.21400 27.25000 -90.82470 27.55000] OR bounding_box:[-90.82470 27.25000 -90.43540 27.55000] OR bounding_box:[-90.43540 27.25000 -90.04610 27.55000] OR bounding_box:[-90.04610 27.25000 -89.65680 27.55000] OR bounding_box:[-89.65680 27.25000 -89.50000 27.55000] OR bounding_box:[-99.00000 27.55000 -98.60970 27.85000] OR bounding_box:[-98.60970 27.55000 -98.21940 27.85000] OR bounding_box:[-98.21940 27.55000 -97.82910 27.85000] OR bounding_box:[-97.82910 27.55000 -97.43880 27.85000] OR bounding_box:[-97.43880 27.55000 -97.04850 27.85000] OR bounding_box:[-97.04850 27.55000 -96.65820 27.85000] OR bounding_box:[-96.65820 27.55000 -96.26790 27.85000])
{rule clauses} (bounding_box:[-96.26790 27.55000 -95.87760 27.85000] OR bounding_box:[-95.87760 27.55000 -95.48730 27.85000] OR bounding_box:[-95.48730 27.55000 -95.09700 27.85000] OR bounding_box:[-95.09700 27.55000 -94.70670 27.85000] OR bounding_box:[-94.70670 27.55000 -94.31640 27.85000] OR bounding_box:[-94.31640 27.55000 -93.92610 27.85000] OR bounding_box:[-93.92610 27.55000 -93.53580 27.85000] OR bounding_box:[-93.53580 27.55000 -93.14550 27.85000] OR bounding_box:[-93.14550 27.55000 -92.75520 27.85000] OR bounding_box:[-92.75520 27.55000 -92.36490 27.85000] OR bounding_box:[-92.36490 27.55000 -91.97460 27.85000] OR bounding_box:[-91.97460 27.55000 -91.58430 27.85000] OR bounding_box:[-91.58430 27.55000 -91.19400 27.85000] OR bounding_box:[-91.19400 27.55000 -90.80370 27.85000] OR bounding_box:[-90.80370 27.55000 -90.41340 27.85000])
{rule clauses} (bounding_box:[-90.41340 27.55000 -90.02310 27.85000] OR bounding_box:[-90.02310 27.55000 -89.63280 27.85000] OR bounding_box:[-89.63280 27.55000 -89.50000 27.85000] OR bounding_box:[-99.00000 27.85000 -98.60860 28.15000] OR bounding_box:[-98.60860 27.85000 -98.21720 28.15000] OR bounding_box:[-98.21720 27.85000 -97.82580 28.15000] OR bounding_box:[-97.82580 27.85000 -97.43440 28.15000] OR bounding_box:[-97.43440 27.85000 -97.04300 28.15000] OR bounding_box:[-97.04300 27.85000 -96.65160 28.15000] OR bounding_box:[-96.65160 27.85000 -96.26020 28.15000] OR bounding_box:[-96.26020 27.85000 -95.86880 28.15000] OR bounding_box:[-95.86880 27.85000 -95.47740 28.15000] OR bounding_box:[-95.47740 27.85000 -95.08600 28.15000] OR bounding_box:[-95.08600 27.85000 -94.69460 28.15000] OR bounding_box:[-94.69460 27.85000 -94.30320 28.15000])
{rule clauses} (bounding_box:[-94.30320 27.85000 -93.91180 28.15000] OR bounding_box:[-93.91180 27.85000 -93.52040 28.15000] OR bounding_box:[-93.52040 27.85000 -93.12900 28.15000] OR bounding_box:[-93.12900 27.85000 -92.73760 28.15000] OR bounding_box:[-92.73760 27.85000 -92.34620 28.15000] OR bounding_box:[-92.34620 27.85000 -91.95480 28.15000] OR bounding_box:[-91.95480 27.85000 -91.56340 28.15000] OR bounding_box:[-91.56340 27.85000 -91.17200 28.15000] OR bounding_box:[-91.17200 27.85000 -90.78060 28.15000] OR bounding_box:[-90.78060 27.85000 -90.38920 28.15000] OR bounding_box:[-90.38920 27.85000 -89.99780 28.15000] OR bounding_box:[-89.99780 27.85000 -89.60640 28.15000] OR bounding_box:[-89.60640 27.85000 -89.50000 28.15000] OR bounding_box:[-99.00000 28.15000 -98.60750 28.45000] OR bounding_box:[-98.60750 28.15000 -98.21500 28.45000])
{rule clauses} (bounding_box:[-98.21500 28.15000 -97.82250 28.45000] OR bounding_box:[-97.82250 28.15000 -97.43000 28.45000] OR bounding_box:[-97.43000 28.15000 -97.03750 28.45000] OR bounding_box:[-97.03750 28.15000 -96.64500 28.45000] OR bounding_box:[-96.64500 28.15000 -96.25250 28.45000] OR bounding_box:[-96.25250 28.15000 -95.86000 28.45000] OR bounding_box:[-95.86000 28.15000 -95.46750 28.45000] OR bounding_box:[-95.46750 28.15000 -95.07500 28.45000] OR bounding_box:[-95.07500 28.15000 -94.68250 28.45000] OR bounding_box:[-94.68250 28.15000 -94.29000 28.45000] OR bounding_box:[-94.29000 28.15000 -93.89750 28.45000] OR bounding_box:[-93.89750 28.15000 -93.50500 28.45000] OR bounding_box:[-93.50500 28.15000 -93.11250 28.45000] OR bounding_box:[-93.11250 28.15000 -92.72000 28.45000] OR bounding_box:[-92.72000 28.15000 -92.32750 28.45000])
{rule clauses} (bounding_box:[-92.32750 28.15000 -91.93500 28.45000] OR bounding_box:[-91.93500 28.15000 -91.54250 28.45000] OR bounding_box:[-91.54250 28.15000 -91.15000 28.45000] OR bounding_box:[-91.15000 28.15000 -90.75750 28.45000] OR bounding_box:[-90.75750 28.15000 -90.36500 28.45000] OR bounding_box:[-90.36500 28.15000 -89.97250 28.45000] OR bounding_box:[-89.97250 28.15000 -89.58000 28.45000] OR bounding_box:[-89.58000 28.15000 -89.50000 28.45000] OR bounding_box:[-99.00000 28.45000 -98.60640 28.75000] OR bounding_box:[-98.60640 28.45000 -98.21280 28.75000] OR bounding_box:[-98.21280 28.45000 -97.81920 28.75000] OR bounding_box:[-97.81920 28.45000 -97.42560 28.75000] OR bounding_box:[-97.42560 28.45000 -97.03200 28.75000] OR bounding_box:[-97.03200 28.45000 -96.63840 28.75000] OR bounding_box:[-96.63840 28.45000 -96.24480 28.75000])
{rule clauses} (bounding_box:[-96.24480 28.45000 -95.85120 28.75000] OR bounding_box:[-95.85120 28.45000 -95.45760 28.75000] OR bounding_box:[-95.45760 28.45000 -95.06400 28.75000] OR bounding_box:[-95.06400 28.45000 -94.67040 28.75000] OR bounding_box:[-94.67040 28.45000 -94.27680 28.75000] OR bounding_box:[-94.27680 28.45000 -93.88320 28.75000] OR bounding_box:[-93.88320 28.45000 -93.48960 28.75000] OR bounding_box:[-93.48960 28.45000 -93.09600 28.75000] OR bounding_box:[-93.09600 28.45000 -92.70240 28.75000] OR bounding_box:[-92.70240 28.45000 -92.30880 28.75000] OR bounding_box:[-92.30880 28.45000 -91.91520 28.75000] OR bounding_box:[-91.91520 28.45000 -91.52160 28.75000] OR bounding_box:[-91.52160 28.45000 -91.12800 28.75000] OR bounding_box:[-91.12800 28.45000 -90.73440 28.75000] OR bounding_box:[-90.73440 28.45000 -90.34080 28.75000])
{rule clauses} (bounding_box:[-90.34080 28.45000 -89.94720 28.75000] OR bounding_box:[-89.94720 28.45000 -89.55360 28.75000] OR bounding_box:[-89.55360 28.45000 -89.50000 28.75000] OR bounding_box:[-99.00000 28.75000 -98.60530 29.05000] OR bounding_box:[-98.60530 28.75000 -98.21060 29.05000] OR bounding_box:[-98.21060 28.75000 -97.81590 29.05000] OR bounding_box:[-97.81590 28.75000 -97.42120 29.05000] OR bounding_box:[-97.42120 28.75000 -97.02650 29.05000] OR bounding_box:[-97.02650 28.75000 -96.63180 29.05000] OR bounding_box:[-96.63180 28.75000 -96.23710 29.05000] OR bounding_box:[-96.23710 28.75000 -95.84240 29.05000] OR bounding_box:[-95.84240 28.75000 -95.44770 29.05000] OR bounding_box:[-95.44770 28.75000 -95.05300 29.05000] OR bounding_box:[-95.05300 28.75000 -94.65830 29.05000] OR bounding_box:[-94.65830 28.75000 -94.26360 29.05000])
{rule clauses} (bounding_box:[-94.26360 28.75000 -93.86890 29.05000] OR bounding_box:[-93.86890 28.75000 -93.47420 29.05000] OR bounding_box:[-93.47420 28.75000 -93.07950 29.05000] OR bounding_box:[-93.07950 28.75000 -92.68480 29.05000] OR bounding_box:[-92.68480 28.75000 -92.29010 29.05000] OR bounding_box:[-92.29010 28.75000 -91.89540 29.05000] OR bounding_box:[-91.89540 28.75000 -91.50070 29.05000] OR bounding_box:[-91.50070 28.75000 -91.10600 29.05000] OR bounding_box:[-91.10600 28.75000 -90.71130 29.05000] OR bounding_box:[-90.71130 28.75000 -90.31660 29.05000] OR bounding_box:[-90.31660 28.75000 -89.92190 29.05000] OR bounding_box:[-89.92190 28.75000 -89.52720 29.05000] OR bounding_box:[-89.52720 28.75000 -89.50000 29.05000] OR bounding_box:[-99.00000 29.05000 -98.60420 29.35000] OR bounding_box:[-98.60420 29.05000 -98.20840 29.35000])
{rule clauses} (bounding_box:[-98.20840 29.05000 -97.81260 29.35000] OR bounding_box:[-97.81260 29.05000 -97.41680 29.35000] OR bounding_box:[-97.41680 29.05000 -97.02100 29.35000] OR bounding_box:[-97.02100 29.05000 -96.62520 29.35000] OR bounding_box:[-96.62520 29.05000 -96.22940 29.35000] OR bounding_box:[-96.22940 29.05000 -95.83360 29.35000] OR bounding_box:[-95.83360 29.05000 -95.43780 29.35000] OR bounding_box:[-95.43780 29.05000 -95.04200 29.35000] OR bounding_box:[-95.04200 29.05000 -94.64620 29.35000] OR bounding_box:[-94.64620 29.05000 -94.25040 29.35000] OR bounding_box:[-94.25040 29.05000 -93.85460 29.35000] OR bounding_box:[-93.85460 29.05000 -93.45880 29.35000] OR bounding_box:[-93.45880 29.05000 -93.06300 29.35000] OR bounding_box:[-93.06300 29.05000 -92.66720 29.35000] OR bounding_box:[-92.66720 29.05000 -92.27140 29.35000])
{rule clauses} (bounding_box:[-92.27140 29.05000 -91.87560 29.35000] OR bounding_box:[-91.87560 29.05000 -91.47980 29.35000] OR bounding_box:[-91.47980 29.05000 -91.08400 29.35000] OR bounding_box:[-91.08400 29.05000 -90.68820 29.35000] OR bounding_box:[-90.68820 29.05000 -90.29240 29.35000] OR bounding_box:[-90.29240 29.05000 -89.89660 29.35000] OR bounding_box:[-89.89660 29.05000 -89.50080 29.35000] OR bounding_box:[-89.50080 29.05000 -89.50000 29.35000] OR bounding_box:[-99.00000 29.35000 -98.60310 29.65000] OR bounding_box:[-98.60310 29.35000 -98.20620 29.65000] OR bounding_box:[-98.20620 29.35000 -97.80930 29.65000] OR bounding_box:[-97.80930 29.35000 -97.41240 29.65000] OR bounding_box:[-97.41240 29.35000 -97.01550 29.65000] OR bounding_box:[-97.01550 29.35000 -96.61860 29.65000] OR bounding_box:[-96.61860 29.35000 -96.22170 29.65000])
{rule clauses} (bounding_box:[-96.22170 29.35000 -95.82480 29.65000] OR bounding_box:[-95.82480 29.35000 -95.42790 29.65000] OR bounding_box:[-95.42790 29.35000 -95.03100 29.65000] OR bounding_box:[-95.03100 29.35000 -94.63410 29.65000] OR bounding_box:[-94.63410 29.35000 -94.23720 29.65000] OR bounding_box:[-94.23720 29.35000 -93.84030 29.65000] OR bounding_box:[-93.84030 29.35000 -93.44340 29.65000] OR bounding_box:[-93.44340 29.35000 -93.04650 29.65000] OR bounding_box:[-93.04650 29.35000 -92.64960 29.65000] OR bounding_box:[-92.64960 29.35000 -92.25270 29.65000] OR bounding_box:[-92.25270 29.35000 -91.85580 29.65000] OR bounding_box:[-91.85580 29.35000 -91.45890 29.65000] OR bounding_box:[-91.45890 29.35000 -91.06200 29.65000] OR bounding_box:[-91.06200 29.35000 -90.66510 29.65000] OR bounding_box:[-90.66510 29.35000 -90.26820 29.65000])
{rule clauses} (bounding_box:[-90.26820 29.35000 -89.87130 29.65000] OR bounding_box:[-89.87130 29.35000 -89.50000 29.65000] OR bounding_box:[-99.00000 29.65000 -98.60190 29.95000] OR bounding_box:[-98.60190 29.65000 -98.20380 29.95000] OR bounding_box:[-98.20380 29.65000 -97.80570 29.95000] OR bounding_box:[-97.80570 29.65000 -97.40760 29.95000] OR bounding_box:[-97.40760 29.65000 -97.00950 29.95000] OR bounding_box:[-97.00950 29.65000 -96.61140 29.95000] OR bounding_box:[-96.61140 29.65000 -96.21330 29.95000] OR bounding_box:[-96.21330 29.65000 -95.81520 29.95000] OR bounding_box:[-95.81520 29.65000 -95.41710 29.95000] OR bounding_box:[-95.41710 29.65000 -95.01900 29.95000] OR bounding_box:[-95.01900 29.65000 -94.62090 29.95000] OR bounding_box:[-94.62090 29.65000 -94.22280 29.95000] OR bounding_box:[-94.22280 29.65000 -93.82470 29.95000])
{rule clauses} (bounding_box:[-93.82470 29.65000 -93.42660 29.95000] OR bounding_box:[-93.42660 29.65000 -93.02850 29.95000] OR bounding_box:[-93.02850 29.65000 -92.63040 29.95000] OR bounding_box:[-92.63040 29.65000 -92.23230 29.95000] OR bounding_box:[-92.23230 29.65000 -91.83420 29.95000] OR bounding_box:[-91.83420 29.65000 -91.43610 29.95000] OR bounding_box:[-91.43610 29.65000 -91.03800 29.95000] OR bounding_box:[-91.03800 29.65000 -90.63990 29.95000] OR bounding_box:[-90.63990 29.65000 -90.24180 29.95000] OR bounding_box:[-90.24180 29.65000 -89.84370 29.95000] OR bounding_box:[-89.84370 29.65000 -89.50000 29.95000] OR bounding_box:[-99.00000 29.95000 -98.60070 30.25000] OR bounding_box:[-98.60070 29.95000 -98.20140 30.25000] OR bounding_box:[-98.20140 29.95000 -97.80210 30.25000] OR bounding_box:[-97.80210 29.95000 -97.40280 30.25000])
{rule clauses} (bounding_box:[-97.40280 29.95000 -97.00350 30.25000] OR bounding_box:[-97.00350 29.95000 -96.60420 30.25000] OR bounding_box:[-96.60420 29.95000 -96.20490 30.25000] OR bounding_box:[-96.20490 29.95000 -95.80560 30.25000] OR bounding_box:[-95.80560 29.95000 -95.40630 30.25000] OR bounding_box:[-95.40630 29.95000 -95.00700 30.25000] OR bounding_box:[-95.00700 29.95000 -94.60770 30.25000] OR bounding_box:[-94.60770 29.95000 -94.20840 30.25000] OR bounding_box:[-94.20840 29.95000 -93.80910 30.25000] OR bounding_box:[-93.80910 29.95000 -93.40980 30.25000] OR bounding_box:[-93.40980 29.95000 -93.01050 30.25000] OR bounding_box:[-93.01050 29.95000 -92.61120 30.25000] OR bounding_box:[-92.61120 29.95000 -92.21190 30.25000] OR bounding_box:[-92.21190 29.95000 -91.81260 30.25000] OR bounding_box:[-91.81260 29.95000 -91.41330 30.25000])
{rule clauses} (bounding_box:[-91.41330 29.95000 -91.01400 30.25000] OR bounding_box:[-91.01400 29.95000 -90.61470 30.25000] OR bounding_box:[-90.61470 29.95000 -90.21540 30.25000] OR bounding_box:[-90.21540 29.95000 -89.81610 30.25000] OR bounding_box:[-89.81610 29.95000 -89.50000 30.25000] OR bounding_box:[-99.00000 30.25000 -98.59950 30.55000] OR bounding_box:[-98.59950 30.25000 -98.19900 30.55000] OR bounding_box:[-98.19900 30.25000 -97.79850 30.55000] OR bounding_box:[-97.79850 30.25000 -97.39800 30.55000] OR bounding_box:[-97.39800 30.25000 -96.99750 30.55000] OR bounding_box:[-96.99750 30.25000 -96.59700 30.55000] OR bounding_box:[-96.59700 30.25000 -96.19650 30.55000] OR bounding_box:[-96.19650 30.25000 -95.79600 30.55000] OR bounding_box:[-95.79600 30.25000 -95.39550 30.55000] OR bounding_box:[-95.39550 30.25000 -94.99500 30.55000])
{rule clauses} (bounding_box:[-94.99500 30.25000 -94.59450 30.55000] OR bounding_box:[-94.59450 30.25000 -94.19400 30.55000] OR bounding_box:[-94.19400 30.25000 -93.79350 30.55000] OR bounding_box:[-93.79350 30.25000 -93.39300 30.55000] OR bounding_box:[-93.39300 30.25000 -92.99250 30.55000] OR bounding_box:[-92.99250 30.25000 -92.59200 30.55000] OR bounding_box:[-92.59200 30.25000 -92.19150 30.55000] OR bounding_box:[-92.19150 30.25000 -91.79100 30.55000] OR bounding_box:[-91.79100 30.25000 -91.39050 30.55000] OR bounding_box:[-91.39050 30.25000 -90.99000 30.55000] OR bounding_box:[-90.99000 30.25000 -90.58950 30.55000] OR bounding_box:[-90.58950 30.25000 -90.18900 30.55000] OR bounding_box:[-90.18900 30.25000 -89.78850 30.55000] OR bounding_box:[-89.78850 30.25000 -89.50000 30.55000] OR bounding_box:[-99.00000 30.55000 -98.59830 30.85000])
{rule clauses} (bounding_box:[-98.59830 30.55000 -98.19660 30.85000] OR bounding_box:[-98.19660 30.55000 -97.79490 30.85000] OR bounding_box:[-97.79490 30.55000 -97.39320 30.85000] OR bounding_box:[-97.39320 30.55000 -96.99150 30.85000] OR bounding_box:[-96.99150 30.55000 -96.58980 30.85000] OR bounding_box:[-96.58980 30.55000 -96.18810 30.85000] OR bounding_box:[-96.18810 30.55000 -95.78640 30.85000] OR bounding_box:[-95.78640 30.55000 -95.38470 30.85000] OR bounding_box:[-95.38470 30.55000 -94.98300 30.85000] OR bounding_box:[-94.98300 30.55000 -94.58130 30.85000] OR bounding_box:[-94.58130 30.55000 -94.17960 30.85000] OR bounding_box:[-94.17960 30.55000 -93.77790 30.85000] OR bounding_box:[-93.77790 30.55000 -93.37620 30.85000] OR bounding_box:[-93.37620 30.55000 -92.97450 30.85000] OR bounding_box:[-92.97450 30.55000 -92.57280 30.85000])
{rule clauses} (bounding_box:[-92.57280 30.55000 -92.17110 30.85000] OR bounding_box:[-92.17110 30.55000 -91.76940 30.85000] OR bounding_box:[-91.76940 30.55000 -91.36770 30.85000] OR bounding_box:[-91.36770 30.55000 -90.96600 30.85000] OR bounding_box:[-90.96600 30.55000 -90.56430 30.85000] OR bounding_box:[-90.56430 30.55000 -90.16260 30.85000] OR bounding_box:[-90.16260 30.55000 -89.76090 30.85000] OR bounding_box:[-89.76090 30.55000 -89.50000 30.85000] OR bounding_box:[-99.00000 30.85000 -98.59710 31.15000] OR bounding_box:[-98.59710 30.85000 -98.19420 31.15000] OR bounding_box:[-98.19420 30.85000 -97.79130 31.15000] OR bounding_box:[-97.79130 30.85000 -97.38840 31.15000] OR bounding_box:[-97.38840 30.85000 -96.98550 31.15000] OR bounding_box:[-96.98550 30.85000 -96.58260 31.15000] OR bounding_box:[-96.58260 30.85000 -96.17970 31.15000])
{rule clauses} (bounding_box:[-96.17970 30.85000 -95.77680 31.15000] OR bounding_box:[-95.77680 30.85000 -95.37390 31.15000] OR bounding_box:[-95.37390 30.85000 -94.97100 31.15000] OR bounding_box:[-94.97100 30.85000 -94.56810 31.15000] OR bounding_box:[-94.56810 30.85000 -94.16520 31.15000] OR bounding_box:[-94.16520 30.85000 -93.76230 31.15000] OR bounding_box:[-93.76230 30.85000 -93.35940 31.15000] OR bounding_box:[-93.35940 30.85000 -92.95650 31.15000] OR bounding_box:[-92.95650 30.85000 -92.55360 31.15000] OR bounding_box:[-92.55360 30.85000 -92.15070 31.15000] OR bounding_box:[-92.15070 30.85000 -91.74780 31.15000] OR bounding_box:[-91.74780 30.85000 -91.34490 31.15000] OR bounding_box:[-91.34490 30.85000 -90.94200 31.15000] OR bounding_box:[-90.94200 30.85000 -90.53910 31.15000] OR bounding_box:[-90.53910 30.85000 -90.13620 31.15000])
{rule clauses} (bounding_box:[-90.13620 30.85000 -89.73330 31.15000] OR bounding_box:[-89.73330 30.85000 -89.50000 31.15000] OR bounding_box:[-99.00000 31.15000 -98.59580 31.45000] OR bounding_box:[-98.59580 31.15000 -98.19160 31.45000] OR bounding_box:[-98.19160 31.15000 -97.78740 31.45000] OR bounding_box:[-97.78740 31.15000 -97.38320 31.45000] OR bounding_box:[-97.38320 31.15000 -96.97900 31.45000] OR bounding_box:[-96.97900 31.15000 -96.57480 31.45000] OR bounding_box:[-96.57480 31.15000 -96.17060 31.45000] OR bounding_box:[-96.17060 31.15000 -95.76640 31.45000] OR bounding_box:[-95.76640 31.15000 -95.36220 31.45000] OR bounding_box:[-95.36220 31.15000 -94.95800 31.45000] OR bounding_box:[-94.95800 31.15000 -94.55380 31.45000] OR bounding_box:[-94.55380 31.15000 -94.14960 31.45000] OR bounding_box:[-94.14960 31.15000 -93.74540 31.45000])
{rule clauses} (bounding_box:[-93.74540 31.15000 -93.34120 31.45000] OR bounding_box:[-93.34120 31.15000 -92.93700 31.45000] OR bounding_box:[-92.93700 31.15000 -92.53280 31.45000] OR bounding_box:[-92.53280 31.15000 -92.12860 31.45000] OR bounding_box:[-92.12860 31.15000 -91.72440 31.45000] OR bounding_box:[-91.72440 31.15000 -91.32020 31.45000] OR bounding_box:[-91.32020 31.15000 -90.91600 31.45000] OR bounding_box:[-90.91600 31.15000 -90.51180 31.45000] OR bounding_box:[-90.51180 31.15000 -90.10760 31.45000] OR bounding_box:[-90.10760 31.15000 -89.70340 31.45000] OR bounding_box:[-89.70340 31.15000 -89.50000 31.45000] OR bounding_box:[-99.00000 31.45000 -98.59450 31.75000] OR bounding_box:[-98.59450 31.45000 -98.18900 31.75000] OR bounding_box:[-98.18900 31.45000 -97.78350 31.75000] OR bounding_box:[-97.78350 31.45000 -97.37800 31.75000])
{rule clauses} (bounding_box:[-97.37800 31.45000 -96.97250 31.75000] OR bounding_box:[-96.97250 31.45000 -96.56700 31.75000] OR bounding_box:[-96.56700 31.45000 -96.16150 31.75000] OR bounding_box:[-96.16150 31.45000 -95.75600 31.75000] OR bounding_box:[-95.75600 31.45000 -95.35050 31.75000] OR bounding_box:[-95.35050 31.45000 -94.94500 31.75000] OR bounding_box:[-94.94500 31.45000 -94.53950 31.75000] OR bounding_box:[-94.53950 31.45000 -94.13400 31.75000] OR bounding_box:[-94.13400 31.45000 -93.72850 31.75000] OR bounding_box:[-93.72850 31.45000 -93.32300 31.75000] OR bounding_box:[-93.32300 31.45000 -92.91750 31.75000] OR bounding_box:[-92.91750 31.45000 -92.51200 31.75000] OR bounding_box:[-92.51200 31.45000 -92.10650 31.75000] OR bounding_box:[-92.10650 31.45000 -91.70100 31.75000] OR bounding_box:[-91.70100 31.45000 -91.29550 31.75000])
{rule clauses} (bounding_box:[-91.29550 31.45000 -90.89000 31.75000] OR bounding_box:[-90.89000 31.45000 -90.48450 31.75000] OR bounding_box:[-90.48450 31.45000 -90.07900 31.75000] OR bounding_box:[-90.07900 31.45000 -89.67350 31.75000] OR bounding_box:[-89.67350 31.45000 -89.50000 31.75000] OR bounding_box:[-99.00000 31.75000 -98.59320 32.00000] OR bounding_box:[-98.59320 31.75000 -98.18640 32.00000] OR bounding_box:[-98.18640 31.75000 -97.77960 32.00000] OR bounding_box:[-97.77960 31.75000 -97.37280 32.00000] OR bounding_box:[-97.37280 31.75000 -96.96600 32.00000] OR bounding_box:[-96.96600 31.75000 -96.55920 32.00000] OR bounding_box:[-96.55920 31.75000 -96.15240 32.00000] OR bounding_box:[-96.15240 31.75000 -95.74560 32.00000] OR bounding_box:[-95.74560 31.75000 -95.33880 32.00000] OR bounding_box:[-95.33880 31.75000 -94.93200 32.00000])
{rule clauses} (bounding_box:[-94.93200 31.75000 -94.52520 32.00000] OR bounding_box:[-94.52520 31.75000 -94.11840 32.00000] OR bounding_box:[-94.11840 31.75000 -93.71160 32.00000] OR bounding_box:[-93.71160 31.75000 -93.30480 32.00000] OR bounding_box:[-93.30480 31.75000 -92.89800 32.00000] OR bounding_box:[-92.89800 31.75000 -92.49120 32.00000] OR bounding_box:[-92.49120 31.75000 -92.08440 32.00000] OR bounding_box:[-92.08440 31.75000 -91.67760 32.00000] OR bounding_box:[-91.67760 31.75000 -91.27080 32.00000] OR bounding_box:[-91.27080 31.75000 -90.86400 32.00000] OR bounding_box:[-90.86400 31.75000 -90.45720 32.00000] OR bounding_box:[-90.45720 31.75000 -90.05040 32.00000] OR bounding_box:[-90.05040 31.75000 -89.64360 32.00000] OR bounding_box:[-89.64360 31.75000 -89.50000 32.00000])
```




