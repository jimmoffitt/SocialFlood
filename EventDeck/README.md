
## EventDeck
#### Otherwise known as the "poorman's TweetDeck."

EventDeck is a demo put together to illustrate how the 2013 Colorado Flood unfolded on Twitter.

EventDeck receives a Tweet stream and displays them ala TweetDeck with Tweets organized in pre-defined columns.


 ![](https://raw.githubusercontent.com/jimmoffitt/SocialFlood/master/EventDeck/imgs/flood_event_deck.png)




Dependencies:

* bullet.js
* websocket app that provides data via ```var socket = io.connect('http://127.0.0.1:7008/')```


```
socket.on('tweet', handleTweet); //Tweet arrived, go handle it!
```

```
if (tags.indexOf("agency") >= 0 ) {
   //column 1
}
else if (tags.indexOf("media") >= 0 ) {
 	//column 2
}
else if (tags.indexOf("flood_tag") >= 0 ) {
	//column 3
}
else {
	//column 4
}
```

### Event Rules and Tags

```
{
  "rules": [
    {
      "value": "-is:retweet has:media profile_region:colorado (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "profile_geo, has_media"
    },
    {
      "value": "-is:retweet has:geo profile_region:colorado (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "profile_geo"
    },
    {
      "value": "-is:retweet (from:boulderoem OR from:nwsboulder OR from:coemergency OR from:bouldercounty)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (from:bouldercolorado OR from:cityoflongmont) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (to:boulderoem OR @bouldereom OR to:nwsboulder OR @nwsboulder OR to:coemergency OR @coemergency OR to:boundercounty OR @bouldercounty) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "to_agency"
    },
    {
      "value": "-is:retweet (from:fema OR from:femaregion8) (colorado OR boulder OR longmont OR denver) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (to:fema OR @fema OR to:femaregion8 OR @femaregion8) (colorado OR boulder OR longmont OR denver) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "to_agency"
    },
    {
      "value": "-is:retweet (from:9news OR from:dailycamera OR from:timescall OR from:denverchannel) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_media"
    },
    {
      "value": "-is:retweet from:twcbreaking (colorado OR boulder OR longmont OR lyons OR jamestown)",
      "tag": "from_media"
    },
    {
      "value": "-is:retweet from:jeffcosheriffco (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (#bouldercreek OR #stvrainriver OR #stvrain OR #stvraincreek OR #lefthandcreek OR #lefthand OR #lefthandcanyon OR #bigthompsonriver OR #bigthompson OR #southplatteriver OR #southplatte)",
      "tag": "river"
    },
    {
      "value": "-is:retweet profile_region:colorado (#COFlood OR #ColoradoFlood OR #boulderflood OR #longmontflood OR #lovelandflood OR #lyonsflood OR #jamestownflood OR (estesflood OR #estesparkflood) OR #arvadaflood OR #greelyflood OR #denverflood OR #jeffcoflood OR weldcoflood)",
      "tag": "flood_tag"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-109.00000 37.00000 -108.65000 37.30000] OR bounding_box:[-108.65000 37.00000 -108.30000 37.30000] OR bounding_box:[-108.30000 37.00000 -107.95000 37.30000] OR bounding_box:[-107.95000 37.00000 -107.60000 37.30000] OR bounding_box:[-107.60000 37.00000 -107.25000 37.30000] OR bounding_box:[-107.25000 37.00000 -106.90000 37.30000] OR bounding_box:[-106.90000 37.00000 -106.55000 37.30000] OR bounding_box:[-106.55000 37.00000 -106.20000 37.30000] OR bounding_box:[-106.20000 37.00000 -105.85000 37.30000] OR bounding_box:[-105.85000 37.00000 -105.50000 37.30000] OR bounding_box:[-105.50000 37.00000 -105.15000 37.30000] OR bounding_box:[-105.15000 37.00000 -104.80000 37.30000] OR bounding_box:[-104.80000 37.00000 -104.45000 37.30000])",
      "tag": "hydrology_geo_tagged"
    }
```


#### Entire JSON ruleset.

```
{
  "rules": [
    {
      "value": "-is:retweet has:media profile_region:colorado (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "profile_geo, has_media"
    },
    {
      "value": "-is:retweet has:geo profile_region:colorado (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "profile_geo"
    },
    {
      "value": "-is:retweet (from:boulderoem OR from:nwsboulder OR from:coemergency OR from:bouldercounty)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (from:bouldercolorado OR from:cityoflongmont) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (to:boulderoem OR @bouldereom OR to:nwsboulder OR @nwsboulder OR to:coemergency OR @coemergency OR to:boundercounty OR @bouldercounty) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "to_agency"
    },
    {
      "value": "-is:retweet (from:fema OR from:femaregion8) (colorado OR boulder OR longmont OR denver) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (to:fema OR @fema OR to:femaregion8 OR @femaregion8) (colorado OR boulder OR longmont OR denver) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "to_agency"
    },
    {
      "value": "-is:retweet (from:9news OR from:dailycamera OR from:timescall OR from:denverchannel) (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_media"
    },
    {
      "value": "-is:retweet from:twcbreaking (colorado OR boulder OR longmont OR lyons OR jamestown)",
      "tag": "from_media"
    },
    {
      "value": "-is:retweet from:jeffcosheriffco (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR poured OR pouring OR dumping OR \"water deep\"~6 OR disaster)",
      "tag": "from_agency"
    },
    {
      "value": "-is:retweet (#bouldercreek OR #stvrainriver OR #stvrain OR #stvraincreek OR #lefthandcreek OR #lefthand OR #lefthandcanyon OR #bigthompsonriver OR #bigthompson OR #southplatteriver OR #southplatte)",
      "tag": "river"
    },
    {
      "value": "-is:retweet profile_region:colorado (#COFlood OR #ColoradoFlood OR #boulderflood OR #longmontflood OR #lovelandflood OR #lyonsflood OR #jamestownflood OR (estesflood OR #estesparkflood) OR #arvadaflood OR #greelyflood OR #denverflood OR #jeffcoflood OR weldcoflood)",
      "tag": "flood_tag"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-109.00000 37.00000 -108.65000 37.30000] OR bounding_box:[-108.65000 37.00000 -108.30000 37.30000] OR bounding_box:[-108.30000 37.00000 -107.95000 37.30000] OR bounding_box:[-107.95000 37.00000 -107.60000 37.30000] OR bounding_box:[-107.60000 37.00000 -107.25000 37.30000] OR bounding_box:[-107.25000 37.00000 -106.90000 37.30000] OR bounding_box:[-106.90000 37.00000 -106.55000 37.30000] OR bounding_box:[-106.55000 37.00000 -106.20000 37.30000] OR bounding_box:[-106.20000 37.00000 -105.85000 37.30000] OR bounding_box:[-105.85000 37.00000 -105.50000 37.30000] OR bounding_box:[-105.50000 37.00000 -105.15000 37.30000] OR bounding_box:[-105.15000 37.00000 -104.80000 37.30000] OR bounding_box:[-104.80000 37.00000 -104.45000 37.30000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-104.45000 37.00000 -104.10000 37.30000] OR bounding_box:[-104.10000 37.00000 -103.75000 37.30000] OR bounding_box:[-103.75000 37.00000 -103.40000 37.30000] OR bounding_box:[-103.40000 37.00000 -103.05000 37.30000] OR bounding_box:[-103.05000 37.00000 -102.70000 37.30000] OR bounding_box:[-102.70000 37.00000 -102.35000 37.30000] OR bounding_box:[-102.35000 37.00000 -102.00000 37.30000] OR bounding_box:[-102.00000 37.00000 -102.00000 37.30000] OR bounding_box:[-109.00000 37.30000 -108.56550 37.60000] OR bounding_box:[-108.56550 37.30000 -108.13100 37.60000] OR bounding_box:[-108.13100 37.30000 -107.69650 37.60000] OR bounding_box:[-107.69650 37.30000 -107.26200 37.60000] OR bounding_box:[-107.26200 37.30000 -106.82750 37.60000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-106.82750 37.30000 -106.39300 37.60000] OR bounding_box:[-106.39300 37.30000 -105.95850 37.60000] OR bounding_box:[-105.95850 37.30000 -105.52400 37.60000] OR bounding_box:[-105.52400 37.30000 -105.08950 37.60000] OR bounding_box:[-105.08950 37.30000 -104.65500 37.60000] OR bounding_box:[-104.65500 37.30000 -104.22050 37.60000] OR bounding_box:[-104.22050 37.30000 -103.78600 37.60000] OR bounding_box:[-103.78600 37.30000 -103.35150 37.60000] OR bounding_box:[-103.35150 37.30000 -102.91700 37.60000] OR bounding_box:[-102.91700 37.30000 -102.48250 37.60000] OR bounding_box:[-102.48250 37.30000 -102.04800 37.60000] OR bounding_box:[-102.04800 37.30000 -102.00000 37.60000] OR bounding_box:[-109.00000 37.60000 -108.56380 37.90000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-108.56380 37.60000 -108.12760 37.90000] OR bounding_box:[-108.12760 37.60000 -107.69140 37.90000] OR bounding_box:[-107.69140 37.60000 -107.25520 37.90000] OR bounding_box:[-107.25520 37.60000 -106.81900 37.90000] OR bounding_box:[-106.81900 37.60000 -106.38280 37.90000] OR bounding_box:[-106.38280 37.60000 -105.94660 37.90000] OR bounding_box:[-105.94660 37.60000 -105.51040 37.90000] OR bounding_box:[-105.51040 37.60000 -105.07420 37.90000] OR bounding_box:[-105.07420 37.60000 -104.63800 37.90000] OR bounding_box:[-104.63800 37.60000 -104.20180 37.90000] OR bounding_box:[-104.20180 37.60000 -103.76560 37.90000] OR bounding_box:[-103.76560 37.60000 -103.32940 37.90000] OR bounding_box:[-103.32940 37.60000 -102.89320 37.90000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-102.89320 37.60000 -102.45700 37.90000] OR bounding_box:[-102.45700 37.60000 -102.02080 37.90000] OR bounding_box:[-102.02080 37.60000 -102.00000 37.90000] OR bounding_box:[-109.00000 37.90000 -108.56200 38.20000] OR bounding_box:[-108.56200 37.90000 -108.12400 38.20000] OR bounding_box:[-108.12400 37.90000 -107.68600 38.20000] OR bounding_box:[-107.68600 37.90000 -107.24800 38.20000] OR bounding_box:[-107.24800 37.90000 -106.81000 38.20000] OR bounding_box:[-106.81000 37.90000 -106.37200 38.20000] OR bounding_box:[-106.37200 37.90000 -105.93400 38.20000] OR bounding_box:[-105.93400 37.90000 -105.49600 38.20000] OR bounding_box:[-105.49600 37.90000 -105.05800 38.20000] OR bounding_box:[-105.05800 37.90000 -104.62000 38.20000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-104.62000 37.90000 -104.18200 38.20000] OR bounding_box:[-104.18200 37.90000 -103.74400 38.20000] OR bounding_box:[-103.74400 37.90000 -103.30600 38.20000] OR bounding_box:[-103.30600 37.90000 -102.86800 38.20000] OR bounding_box:[-102.86800 37.90000 -102.43000 38.20000] OR bounding_box:[-102.43000 37.90000 -102.00000 38.20000] OR bounding_box:[-109.00000 38.20000 -108.56020 38.50000] OR bounding_box:[-108.56020 38.20000 -108.12040 38.50000] OR bounding_box:[-108.12040 38.20000 -107.68060 38.50000] OR bounding_box:[-107.68060 38.20000 -107.24080 38.50000] OR bounding_box:[-107.24080 38.20000 -106.80100 38.50000] OR bounding_box:[-106.80100 38.20000 -106.36120 38.50000] OR bounding_box:[-106.36120 38.20000 -105.92140 38.50000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-105.92140 38.20000 -105.48160 38.50000] OR bounding_box:[-105.48160 38.20000 -105.04180 38.50000] OR bounding_box:[-105.04180 38.20000 -104.60200 38.50000] OR bounding_box:[-104.60200 38.20000 -104.16220 38.50000] OR bounding_box:[-104.16220 38.20000 -103.72240 38.50000] OR bounding_box:[-103.72240 38.20000 -103.28260 38.50000] OR bounding_box:[-103.28260 38.20000 -102.84280 38.50000] OR bounding_box:[-102.84280 38.20000 -102.40300 38.50000] OR bounding_box:[-102.40300 38.20000 -102.00000 38.50000] OR bounding_box:[-109.00000 38.50000 -108.55840 38.80000] OR bounding_box:[-108.55840 38.50000 -108.11680 38.80000] OR bounding_box:[-108.11680 38.50000 -107.67520 38.80000] OR bounding_box:[-107.67520 38.50000 -107.23360 38.80000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-107.23360 38.50000 -106.79200 38.80000] OR bounding_box:[-106.79200 38.50000 -106.35040 38.80000] OR bounding_box:[-106.35040 38.50000 -105.90880 38.80000] OR bounding_box:[-105.90880 38.50000 -105.46720 38.80000] OR bounding_box:[-105.46720 38.50000 -105.02560 38.80000] OR bounding_box:[-105.02560 38.50000 -104.58400 38.80000] OR bounding_box:[-104.58400 38.50000 -104.14240 38.80000] OR bounding_box:[-104.14240 38.50000 -103.70080 38.80000] OR bounding_box:[-103.70080 38.50000 -103.25920 38.80000] OR bounding_box:[-103.25920 38.50000 -102.81760 38.80000] OR bounding_box:[-102.81760 38.50000 -102.37600 38.80000] OR bounding_box:[-102.37600 38.50000 -102.00000 38.80000] OR bounding_box:[-109.00000 38.80000 -108.55660 39.10000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-108.55660 38.80000 -108.11320 39.10000] OR bounding_box:[-108.11320 38.80000 -107.66980 39.10000] OR bounding_box:[-107.66980 38.80000 -107.22640 39.10000] OR bounding_box:[-107.22640 38.80000 -106.78300 39.10000] OR bounding_box:[-106.78300 38.80000 -106.33960 39.10000] OR bounding_box:[-106.33960 38.80000 -105.89620 39.10000] OR bounding_box:[-105.89620 38.80000 -105.45280 39.10000] OR bounding_box:[-105.45280 38.80000 -105.00940 39.10000] OR bounding_box:[-105.00940 38.80000 -104.56600 39.10000] OR bounding_box:[-104.56600 38.80000 -104.12260 39.10000] OR bounding_box:[-104.12260 38.80000 -103.67920 39.10000] OR bounding_box:[-103.67920 38.80000 -103.23580 39.10000] OR bounding_box:[-103.23580 38.80000 -102.79240 39.10000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-102.79240 38.80000 -102.34900 39.10000] OR bounding_box:[-102.34900 38.80000 -102.00000 39.10000] OR bounding_box:[-109.00000 39.10000 -108.55470 39.40000] OR bounding_box:[-108.55470 39.10000 -108.10940 39.40000] OR bounding_box:[-108.10940 39.10000 -107.66410 39.40000] OR bounding_box:[-107.66410 39.10000 -107.21880 39.40000] OR bounding_box:[-107.21880 39.10000 -106.77350 39.40000] OR bounding_box:[-106.77350 39.10000 -106.32820 39.40000] OR bounding_box:[-106.32820 39.10000 -105.88290 39.40000] OR bounding_box:[-105.88290 39.10000 -105.43760 39.40000] OR bounding_box:[-105.43760 39.10000 -104.99230 39.40000] OR bounding_box:[-104.99230 39.10000 -104.54700 39.40000] OR bounding_box:[-104.54700 39.10000 -104.10170 39.40000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-104.10170 39.10000 -103.65640 39.40000] OR bounding_box:[-103.65640 39.10000 -103.21110 39.40000] OR bounding_box:[-103.21110 39.10000 -102.76580 39.40000] OR bounding_box:[-102.76580 39.10000 -102.32050 39.40000] OR bounding_box:[-102.32050 39.10000 -102.00000 39.40000] OR bounding_box:[-109.00000 39.40000 -108.55290 39.70000] OR bounding_box:[-108.55290 39.40000 -108.10580 39.70000] OR bounding_box:[-108.10580 39.40000 -107.65870 39.70000] OR bounding_box:[-107.65870 39.40000 -107.21160 39.70000] OR bounding_box:[-107.21160 39.40000 -106.76450 39.70000] OR bounding_box:[-106.76450 39.40000 -106.31740 39.70000] OR bounding_box:[-106.31740 39.40000 -105.87030 39.70000] OR bounding_box:[-105.87030 39.40000 -105.42320 39.70000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-105.42320 39.40000 -104.97610 39.70000] OR bounding_box:[-104.97610 39.40000 -104.52900 39.70000] OR bounding_box:[-104.52900 39.40000 -104.08190 39.70000] OR bounding_box:[-104.08190 39.40000 -103.63480 39.70000] OR bounding_box:[-103.63480 39.40000 -103.18770 39.70000] OR bounding_box:[-103.18770 39.40000 -102.74060 39.70000] OR bounding_box:[-102.74060 39.40000 -102.29350 39.70000] OR bounding_box:[-102.29350 39.40000 -102.00000 39.70000] OR bounding_box:[-109.00000 39.70000 -108.55090 40.00000] OR bounding_box:[-108.55090 39.70000 -108.10180 40.00000] OR bounding_box:[-108.10180 39.70000 -107.65270 40.00000] OR bounding_box:[-107.65270 39.70000 -107.20360 40.00000] OR bounding_box:[-107.20360 39.70000 -106.75450 40.00000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-106.75450 39.70000 -106.30540 40.00000] OR bounding_box:[-106.30540 39.70000 -105.85630 40.00000] OR bounding_box:[-105.85630 39.70000 -105.40720 40.00000] OR bounding_box:[-105.40720 39.70000 -104.95810 40.00000] OR bounding_box:[-104.95810 39.70000 -104.50900 40.00000] OR bounding_box:[-104.50900 39.70000 -104.05990 40.00000] OR bounding_box:[-104.05990 39.70000 -103.61080 40.00000] OR bounding_box:[-103.61080 39.70000 -103.16170 40.00000] OR bounding_box:[-103.16170 39.70000 -102.71260 40.00000] OR bounding_box:[-102.71260 39.70000 -102.26350 40.00000] OR bounding_box:[-102.26350 39.70000 -102.00000 40.00000] OR bounding_box:[-109.00000 40.00000 -108.54900 40.30000] OR bounding_box:[-108.54900 40.00000 -108.09800 40.30000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-108.09800 40.00000 -107.64700 40.30000] OR bounding_box:[-107.64700 40.00000 -107.19600 40.30000] OR bounding_box:[-107.19600 40.00000 -106.74500 40.30000] OR bounding_box:[-106.74500 40.00000 -106.29400 40.30000] OR bounding_box:[-106.29400 40.00000 -105.84300 40.30000] OR bounding_box:[-105.84300 40.00000 -105.39200 40.30000] OR bounding_box:[-105.39200 40.00000 -104.94100 40.30000] OR bounding_box:[-104.94100 40.00000 -104.49000 40.30000] OR bounding_box:[-104.49000 40.00000 -104.03900 40.30000] OR bounding_box:[-104.03900 40.00000 -103.58800 40.30000] OR bounding_box:[-103.58800 40.00000 -103.13700 40.30000] OR bounding_box:[-103.13700 40.00000 -102.68600 40.30000] OR bounding_box:[-102.68600 40.00000 -102.23500 40.30000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-102.23500 40.00000 -102.00000 40.30000] OR bounding_box:[-109.00000 40.30000 -108.54700 40.60000] OR bounding_box:[-108.54700 40.30000 -108.09400 40.60000] OR bounding_box:[-108.09400 40.30000 -107.64100 40.60000] OR bounding_box:[-107.64100 40.30000 -107.18800 40.60000] OR bounding_box:[-107.18800 40.30000 -106.73500 40.60000] OR bounding_box:[-106.73500 40.30000 -106.28200 40.60000] OR bounding_box:[-106.28200 40.30000 -105.82900 40.60000] OR bounding_box:[-105.82900 40.30000 -105.37600 40.60000] OR bounding_box:[-105.37600 40.30000 -104.92300 40.60000] OR bounding_box:[-104.92300 40.30000 -104.47000 40.60000] OR bounding_box:[-104.47000 40.30000 -104.01700 40.60000] OR bounding_box:[-104.01700 40.30000 -103.56400 40.60000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-103.56400 40.30000 -103.11100 40.60000] OR bounding_box:[-103.11100 40.30000 -102.65800 40.60000] OR bounding_box:[-102.65800 40.30000 -102.20500 40.60000] OR bounding_box:[-102.20500 40.30000 -102.00000 40.60000] OR bounding_box:[-109.00000 40.60000 -108.54500 40.90000] OR bounding_box:[-108.54500 40.60000 -108.09000 40.90000] OR bounding_box:[-108.09000 40.60000 -107.63500 40.90000] OR bounding_box:[-107.63500 40.60000 -107.18000 40.90000] OR bounding_box:[-107.18000 40.60000 -106.72500 40.90000] OR bounding_box:[-106.72500 40.60000 -106.27000 40.90000] OR bounding_box:[-106.27000 40.60000 -105.81500 40.90000] OR bounding_box:[-105.81500 40.60000 -105.36000 40.90000] OR bounding_box:[-105.36000 40.60000 -104.90500 40.90000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-104.90500 40.60000 -104.45000 40.90000] OR bounding_box:[-104.45000 40.60000 -103.99500 40.90000] OR bounding_box:[-103.99500 40.60000 -103.54000 40.90000] OR bounding_box:[-103.54000 40.60000 -103.08500 40.90000] OR bounding_box:[-103.08500 40.60000 -102.63000 40.90000] OR bounding_box:[-102.63000 40.60000 -102.17500 40.90000] OR bounding_box:[-102.17500 40.60000 -102.00000 40.90000] OR bounding_box:[-109.00000 40.90000 -108.54300 41.00000] OR bounding_box:[-108.54300 40.90000 -108.08600 41.00000] OR bounding_box:[-108.08600 40.90000 -107.62900 41.00000] OR bounding_box:[-107.62900 40.90000 -107.17200 41.00000] OR bounding_box:[-107.17200 40.90000 -106.71500 41.00000] OR bounding_box:[-106.71500 40.90000 -106.25800 41.00000])",
      "tag": "hydrology_geo_tagged"
    },
    {
      "value": "-is:retweet (rain OR rained OR raining OR rainfall OR contains:flood OR contains:precip OR storm OR stormed OR storming OR weather OR pour OR oured OR pouring OR dumping OR \"water deep\"~6 OR disaster) (bounding_box:[-106.25800 40.90000 -105.80100 41.00000] OR bounding_box:[-105.80100 40.90000 -105.34400 41.00000] OR bounding_box:[-105.34400 40.90000 -104.88700 41.00000] OR bounding_box:[-104.88700 40.90000 -104.43000 41.00000] OR bounding_box:[-104.43000 40.90000 -103.97300 41.00000] OR bounding_box:[-103.97300 40.90000 -103.51600 41.00000] OR bounding_box:[-103.51600 40.90000 -103.05900 41.00000] OR bounding_box:[-103.05900 40.90000 -102.60200 41.00000] OR bounding_box:[-102.60200 40.90000 -102.14500 41.00000] OR bounding_box:[-102.14500 40.90000 -102.00000 41.00000])",
      "tag": "hydrology_geo_tagged"
    }
  ]
}
```
