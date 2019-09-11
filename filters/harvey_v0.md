
The following filters were used to compile (and later curate) Tweets for the 'eventViewer' pilot.

```json
{
    "rules" :
        [
            {
                "value" : "-is:retweet (from:HoustonOEM OR from:ReadyHarris OR from:HoustonFire OR from:HoustonTX OR from:JeffLindner1 OR from:NWSHouston OR from:BrazoriaCounty OR from:NWSSanAntonio OR from:HCSOTexas OR from:HoustonChron)",
                "tag" : "official"
            },
            {
                "value" : "has:media profile_region:Texas -is:retweet ((Hurricane Harvey) OR #HarveySOS OR #Harvey OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey)",
                "tag" : "harvey mention, native media, Texas profile"
            },
            {
                "value" : "(url:instagram OR (url:\"photos.google\")) profile_region:Texas -is:retweet ((Hurricane Harvey) OR #HarveySOS OR #Harvey OR #Harvey2017 OR #HarveyStorm OR #HoustonFlood OR #HoustonFloods OR #HoustonFlooding OR #HurricaneHarvey)",
                "tag" : "harvey-mention, linked media, Texas profile"
            },
            {
                "value" : "has:media -is:retweet (bounding_box:[-96.54000 29.80000 -96.19000 30.10000] OR bounding_box:[-96.19000 29.80000 -95.84000 30.10000] OR bounding_box:[-95.84000 29.80000 -95.49000 30.10000] OR bounding_box:[-95.49000 29.80000 -95.14000 30.10000] OR bounding_box:[-95.14000 29.80000 -94.79000 30.10000] OR bounding_box:[-94.79000 29.80000 -94.44000 30.10000] OR bounding_box:[-94.44000 29.80000 -94.09000 30.10000] OR bounding_box:[-94.09000 29.80000 -93.83000 30.10000] OR bounding_box:[-96.54000 30.10000 -96.14010 30.40000] OR bounding_box:[-96.14010 30.10000 -95.74020 30.40000] OR bounding_box:[-95.74020 30.10000 -95.34030 30.40000] OR bounding_box:[-95.34030 30.10000 -94.94040 30.40000] OR bounding_box:[-94.94040 30.10000 -94.54050 30.40000] OR bounding_box:[-94.54050 30.10000 -94.14060 30.40000] OR bounding_box:[-94.14060 30.10000 -93.83000 30.40000])",
                "tag" : "native media, geo"
            },
            {
                "value" : "has:media -is:retweet (bounding_box:[-96.54000 30.40000 -96.13890 30.70000] OR bounding_box:[-96.13890 30.40000 -95.73780 30.70000] OR bounding_box:[-95.73780 30.40000 -95.33670 30.70000] OR bounding_box:[-95.33670 30.40000 -94.93560 30.70000] OR bounding_box:[-94.93560 30.40000 -94.53450 30.70000] OR bounding_box:[-94.53450 30.40000 -94.13340 30.70000] OR bounding_box:[-94.13340 30.40000 -93.83000 30.70000] OR bounding_box:[-96.54000 30.70000 -96.13770 30.83000] OR bounding_box:[-96.13770 30.70000 -95.73540 30.83000] OR bounding_box:[-95.73540 30.70000 -95.33310 30.83000] OR bounding_box:[-95.33310 30.70000 -94.93080 30.83000] OR bounding_box:[-94.93080 30.70000 -94.52850 30.83000] OR bounding_box:[-94.52850 30.70000 -94.12620 30.83000] OR bounding_box:[-94.12620 30.70000 -93.83000 30.83000])",
                "tag" : "native media, geo"
            },
            {
                "value" : "(url:instagram OR (url:\"photos.google\")) -is:retweet (bounding_box:[-96.54000 29.80000 -96.19000 30.10000] OR bounding_box:[-96.19000 29.80000 -95.84000 30.10000] OR bounding_box:[-95.84000 29.80000 -95.49000 30.10000] OR bounding_box:[-95.49000 29.80000 -95.14000 30.10000] OR bounding_box:[-95.14000 29.80000 -94.79000 30.10000] OR bounding_box:[-94.79000 29.80000 -94.44000 30.10000] OR bounding_box:[-94.44000 29.80000 -94.09000 30.10000] OR bounding_box:[-94.09000 29.80000 -93.83000 30.10000] OR bounding_box:[-96.54000 30.10000 -96.14010 30.40000] OR bounding_box:[-96.14010 30.10000 -95.74020 30.40000] OR bounding_box:[-95.74020 30.10000 -95.34030 30.40000] OR bounding_box:[-95.34030 30.10000 -94.94040 30.40000] OR bounding_box:[-94.94040 30.10000 -94.54050 30.40000] OR bounding_box:[-94.54050 30.10000 -94.14060 30.40000] OR bounding_box:[-94.14060 30.10000 -93.83000 30.40000])",
                "tag" : "harvey mention, linked media, geo"
            },
            {
                "value" : "(url:instagram OR (url:\"photos.google\")) -is:retweet (bounding_box:[-96.54000 30.40000 -96.13890 30.70000] OR bounding_box:[-96.13890 30.40000 -95.73780 30.70000] OR bounding_box:[-95.73780 30.40000 -95.33670 30.70000] OR bounding_box:[-95.33670 30.40000 -94.93560 30.70000] OR bounding_box:[-94.93560 30.40000 -94.53450 30.70000] OR bounding_box:[-94.53450 30.40000 -94.13340 30.70000] OR bounding_box:[-94.13340 30.40000 -93.83000 30.70000] OR bounding_box:[-96.54000 30.70000 -96.13770 30.83000] OR bounding_box:[-96.13770 30.70000 -95.73540 30.83000] OR bounding_box:[-95.73540 30.70000 -95.33310 30.83000] OR bounding_box:[-95.33310 30.70000 -94.93080 30.83000] OR bounding_box:[-94.93080 30.70000 -94.52850 30.83000] OR bounding_box:[-94.52850 30.70000 -94.12620 30.83000] OR bounding_box:[-94.12620 30.70000 -93.83000 30.83000])",
                "tag" : "harvey mention, linked media, geo"
            },
            {
                "value" : "(from:USGS_TexasFlood OR from:USGS_TexasRain) -is:retweet (bounding_box:[-96.54000 29.80000 -96.19000 30.10000] OR bounding_box:[-96.19000 29.80000 -95.84000 30.10000] OR bounding_box:[-95.84000 29.80000 -95.49000 30.10000] OR bounding_box:[-95.49000 29.80000 -95.14000 30.10000] OR bounding_box:[-95.14000 29.80000 -94.79000 30.10000] OR bounding_box:[-94.79000 29.80000 -94.44000 30.10000] OR bounding_box:[-94.44000 29.80000 -94.09000 30.10000] OR bounding_box:[-94.09000 29.80000 -93.83000 30.10000] OR bounding_box:[-96.54000 30.10000 -96.14010 30.40000] OR bounding_box:[-96.14010 30.10000 -95.74020 30.40000] OR bounding_box:[-95.74020 30.10000 -95.34030 30.40000] OR bounding_box:[-95.34030 30.10000 -94.94040 30.40000] OR bounding_box:[-94.94040 30.10000 -94.54050 30.40000] OR bounding_box:[-94.54050 30.10000 -94.14060 30.40000] OR bounding_box:[-94.14060 30.10000 -93.83000 30.40000])",
                "tag" : "Texas USGS"
            },
            {
                "value" : "(from:USGS_TexasFlood OR from:USGS_TexasRain) -is:retweet (bounding_box:[-96.54000 30.40000 -96.13890 30.70000] OR bounding_box:[-96.13890 30.40000 -95.73780 30.70000] OR bounding_box:[-95.73780 30.40000 -95.33670 30.70000] OR bounding_box:[-95.33670 30.40000 -94.93560 30.70000] OR bounding_box:[-94.93560 30.40000 -94.53450 30.70000] OR bounding_box:[-94.53450 30.40000 -94.13340 30.70000] OR bounding_box:[-94.13340 30.40000 -93.83000 30.70000] OR bounding_box:[-96.54000 30.70000 -96.13770 30.83000] OR bounding_box:[-96.13770 30.70000 -95.73540 30.83000] OR bounding_box:[-95.73540 30.70000 -95.33310 30.83000] OR bounding_box:[-95.33310 30.70000 -94.93080 30.83000] OR bounding_box:[-94.93080 30.70000 -94.52850 30.83000] OR bounding_box:[-94.52850 30.70000 -94.12620 30.83000] OR bounding_box:[-94.12620 30.70000 -93.83000 30.83000])",
                "tag" : "Texas USGS"
            },
            {
                "value" : "has:media -is:retweet profile_region:Texas (flood OR rain OR storm OR emergency)",
                "tag" : "flood help"
            },
            {
                "value" : "-is:retweet profile_region:Texas (rescue OR ((need OR send) help) OR ((house OR street OR neighborhood) ((under water) OR flooded)) OR (this address) OR (on roof))",
                "tag" : "flood help"
            }
    ]
}


```