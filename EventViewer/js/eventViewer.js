
//
var brush; 
var data_set;
var timeseries1;

//Map functions ---------------------------------------------

function build_map(){ // uses leaflet.js to build a zoomable map

    var map = L.map('map').setView([40.0274,-105.2519],13);
    var stamen = L.tileLayer('http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png', {attribution: 'dev.'}).addTo(map);
    var toolserver = L.tileLayer('http://{s}.www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png');
    var baseLayers = {"stamen": stamen, "toolserver-mapnik":toolserver};
    L.control.layers(baseLayers).addTo(map);
    return map;
}

function add_features_to_map(timeStamp,features,map){ // add features to the map

    features.forEach(function(feature,i){
        //var feature["timeStamp"] = timeStamp;
        //var feature["timeStamp_str"] = timeStamp.toString();

        // add points to map try to do this directly w/ geoJson
        L.geoJson(feature).addTo(map);
    });
}

function add_longlat_to_map(timeStamp,features,map,geoLayer){ // add features to the map

    features.forEach(function(feature,i){
        //var feature["timeStamp"] = timeStamp;
        //var feature["timeStamp_str"] = timeStamp.toString();

        // add points to map try to do this directly w/ geoJson
        geoLayer.addData(feature);
    });
}

function add_points_to_map(data,map){
    var dateArray = Object.keys(data.time_series.interval_data);
    var point_counts = {};
    dateArray.forEach(function(ts){
        if (data.time_series.interval_data[ts].hasOwnProperty("tweets_geo_with_media")){
            data.time_series.interval_data[ts].tweets_geo_with_media.forEach(function(feature){

                // get geo and metadata
                var longitude = feature.coordinates[0];
                var latitude  = feature.coordinates[1];
                var tweetUrl = feature.tweet_url;
                var tweetID = feature.tweet_url.split('/')[5];
                var mediaURL = feature.media;

                  // Use leaflet to add circles to the map
                L.circleMarker([+latitude,+longitude],{
                    color: 'steelblue',
                    fillColor: 'steelblue',
                    fillOpacity: 0.2,
                    radius:10,
                    className: "tweet_location_pre_data"
                }).addTo(map);

                // add data to circles
                d3.select(".tweet_location_pre_data")
                  .classed("tweet_location_pre_data",false)
                  .classed("tweet_location",true)
                  .classed("tweetID_"+tweetID,true)
                  .attr("tweet_url",tweetUrl)
                  .attr("tweetID",tweetID)
                  .attr("timeStamp",ts)
                  .attr("timeStampTag",ts.split(":")[0])
                  .attr("mediaURL",mediaURL);

            });
        }
    })

    // sort points
    var sorted_keys = Object.keys(point_counts).sort(function(a,b){return point_counts[b]-point_counts[a]})

    output=[];

    sorted_keys.forEach(function(name){
        output.push({name:point_counts[name]})
        //output[d]=point_counts[d]
    })
    //console.log(output)
}

//Sizing functions -------------------------------------------------

function set_sizes(){
    console.log('setting sizes')

    // keep all window sizes in scope
    var windowHeight = +window.innerHeight;
    var windowWidth = +window.innerWidth;
    var tweetWidth = 520; //This is a max for a rendered Tweet from widget.

    // map sizes
    var margin = {top: windowHeight*0.01, right: 0, bottom: windowHeight*0.1, left: windowWidth*0.10};

    var sizes = {
            mapWidth: (0.50 * windowWidth)
            , mapHeight: (0.50 * windowHeight)
            , mapLeft: d3.min([(0.02 * windowWidth),20])
            , mapTop: d3.min([(0.05 * windowHeight),30])
            , timeseriesWidth: 0.48 * windowWidth
            , timeseriesHeight: 0.20 * windowHeight
            , timeseriesMarginLeft: (windowWidth * 0.02)+35
            , photoHeight: 0.40 * windowHeight
            , windowHeight: windowHeight
            , windowWidth: windowWidth
    }
    sizes["timeseriesMarginTop"] = (sizes.mapHeight)+ d3.min([(sizes.windowHeight * 0.10),60]);
    sizes["tweetFromMapTop"] = sizes.mapTop;
    sizes["tweetFromMapMarginLeft"] = ( sizes.mapWidth + sizes.mapLeft + d3.min([sizes.windowWidth*0.2,20]));
    sizes["photoMarginLeft"] = sizes.tweetFromMapMarginLeft;
    sizes["tweetsVITMarginLeft"] = sizes.tweetFromMapMarginLeft + tweetWidth;
    sizes["tweetsVITTop"] = sizes.mapTop;

    // ISSUE: need to determine how to get the height of the tweet
    if (d3.select("#tweet_from_map iframe")[0][0] == null){
        var tweetWidgetHeight = 0;
    }else{
        var tweetWidgetHeight = +d3.select("#tweet_from_map iframe")[0][0].height;
    }

    // ISSUE: remove the 155 and replace with `tweetWidgetHeight` once the tweet height is determined.
    sizes["photoTop"] = sizes.tweetFromMapTop + 155  + d3.min([sizes.windowWidth*0.1,20]);

    // adjust map
    d3.select('#map')
      .style('left',sizes.mapLeft + 'px')
      .style('top',sizes.mapTop + 'px')
      .style('width',sizes.mapWidth + 'px')
      .style('height',sizes.mapHeight + 'px');

    // adjust timeseries svg
    d3.select(".timeseries")
      .attr("width", sizes.windowWidth)
      .attr("height", sizes.windowHeight)

    // adjust timeseries volume plot
    d3.select('.volume')
      .style('height',sizes.timeseriesHeight)
      .attr("transform", "translate(" + (sizes.timeseriesMarginLeft) + "," + (sizes.timeseriesMarginTop) + ")");

    // adjust tweet selected from map
    d3.select('#tweet_from_map')
      .style('margin-left',(sizes.tweetFromMapMarginLeft) + 'px')
      .style('top',sizes.tweetFromMapTop+'px');

    // adjust tweet VIT list
    d3.select('#tweets_vit')
      .style('margin-left',(sizes.tweetsVITMarginLeft) + 'px') 
      .style('height',"1200px")
      .style('overflow',"auto")
      .style('position', 'absolute')
      .style('width', tweetWidth + 'px')
      .style('top',sizes.tweetsVITTop  +'px');

    // adjust photo
    d3.select('#photo')
      .style('margin-left',(sizes.tweetFromMapMarginLeft + 50) + 'px')
      .style('top',sizes.photoTop + 'px')
      .style('border-radius','20px')
      .style('height',sizes.photoHeight + 'px');

    var scales = update_scales(sizes);
    return sizes;
}

function update_scales(sizes){
    // function to create x scale
    var x = d3.time.scale()
        .domain([new Date("2013-09-11 01:00:00"), new Date("2013-09-18 00:00:00")])
        .range([0, sizes.timeseriesWidth]);

    // function to create y scale
    var y = d3.scale.linear()
        .range([sizes.timeseriesHeight, 0]);

    // https://github.com/mbostock/d3/wiki/Time-Formatting
    // function to build xAxis options
    var xAxis = d3.svg.axis()
        .scale(x)
        .ticks(Math.max(sizes.timeseriesWidth/200,2))
        .tickFormat(d3.time.format("%b %d"))
        .orient("bottom");

    // function to build yAxis options
    var yAxis = d3.svg.axis()
        .scale(y)
        .ticks(Math.max(sizes.timeseriesHeight/50,2))
        .orient("left");

    return {x:x, y:y, xAxis:xAxis, yAxis:yAxis}

}

function create_timeseries_plot(series1, series2, sizes){
    d3.select(".volume").remove();

    // get scales
    var scales = update_scales(sizes);

    var x = scales.x
      , y = scales.y
      , xAxis = scales.xAxis
      , yAxis = scales.yAxis;

    // function to draw a line given across coordinates (x,y).
    var line = d3.svg.line()
        .x(function(d) { return x(d.key); })
        .y(function(d) { return y(d.value); });

    //Adding a second (optional) plot line.
    var line2 = d3.svg.line()
        .x(function(d) { return x(d.key); })
        .y(function(d) { return y(d.value); });

    // create a container inside a pre-existing "id=timeseries" element.
    var svg = d3.select("#timeseries")
        .classed("timeseries",true)
        .attr("width", sizes.windowWidth)
        .attr("height", sizes.windowHeight)
      .append("g")
        .classed("volume",true)
        .attr("transform", "translate(" + (sizes.timeseriesMarginLeft) + "," + (sizes.timeseriesMarginTop) + ")");

    brush = d3.svg.brush()
        .x(x)
        .extent([new Date("2013-09-17 23:00:00"), new Date("2013-09-18 01:00:00")])
        .on("brush", function() {
            brushed(series1);
        });

    var brushElement = svg.append("g")
        .attr("class", "brushElement")
        .call(brush)
      .selectAll("rect")
        .attr("y", 0)
        .attr("height", sizes.timeseriesHeight);

    // add domain to scales
    x.domain(d3.extent(series1, function(d) { return d.key; }));
    y.domain(d3.extent(series1, function(d) { return d.value; }));

    // create series 1.
    svg.append("path")
      .datum(series1)
      .attr("class", "line")
      .attr("d", line);

    // create series 2.
    svg.append("path")
      .datum(series2)
      .attr("class", "line")
      .style("stroke", "green")
      .attr("d", line2);

    // create x axis
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + sizes.timeseriesHeight+ ")")
        .call(xAxis);

    // create conditional y axis
    if (sizes.windowHeight > 600){
      svg.append("g")
        .attr("class", "y axis")
        .call(yAxis);

      svg.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Tweets");
    };

     //Play button
    playButton(svg, 70 , 300);

}

//brushed function! ---------------------------------------
function brushed(series1){

    /*OK, we want the following:
        Earlier timeperiods are gray
        Current timeperiod is RED
        Future timeperiods are not visible    
    */

    console.log("in brushed...");

    var startDate = new Date();
    var endDate = new Date();

    var extent0 = brush.extent();
    var extent1;

    //if dragging, preserve the width of the extent
    if (d3.event.mode === "move") {
        console.log("In d3 brush move");
        var d0 = d3.time.hour.round(extent0[0]);
        //console.log("d0: " + d0);
        //console.log("extent0[1] - extent0[0]: " + (extent0[1] - extent0[0]));
        var d1 = d3.time.hour.offset(d0,Math.round((extent0[1] - extent0[0]) / 3600 /1000 ));
        //console.log("d1: " + d1);
        extent1 = [d0, d1];
        
    }    
    //otherwise, if resizing, round both dates
    else {
        console.log("should be snapping to even hours");
        extent1 = extent0.map(d3.time.hour.round);
        console.log("extent1: " + extent1);
        console.log("extent1: " + extent1);
        //if empty when rounded use floor and ceil instead
        if (extent1[0] >= extent1[1]) {
            extent1[0] = d3.time.hour.floor(extent0[0]);
            extent1[1] = d3.time.hour.ceil(extent0[1]);
        }
    }

    console.log("extent1: " + extent1);
    brush.extent(extent1);

    d3.selectAll(".tweet_location").each(function(d) {
       // add a border to the tweet list
        d3.select("#tweets")
          .style('border','2px solid');
        var checkDate = new Date(this.getAttribute("timeStamp"));
        var lowExtent = new Date(brush.extent()[0]),
            highExtent  = new Date(brush.extent()[1]);

        startDate = lowExtent;
        endDate = highExtent;    

        //console.log("lowExtent: " + lowExtent + " | highExtent: " + highExtent);

        if (checkDate < lowExtent) {
            d3.select(this).style({fill: "steelblue", stroke: "whitesmoke", "visibility" : "visible"});
        } else if (lowExtent <= checkDate && checkDate <= highExtent) {
            d3.select(this).style({fill: "red", stroke: "red", "visibility" : "visible"});
        } else {
            d3.select(this).style({fill: "gray", stroke: "gray", "visibility" : "hidden"});
        }    

    })

    //console.log("startDate: " + startDate + " | endDate: " + endDate);

    // create an array of tweetID matching the brushed range        
    var tweetIDs = [];    
    var tweet_vit_limit = 10;
    d3.select("#tweets_vit").selectAll('*').remove();

    //console.log("data_set: " + data_set);
    var dataArray = d3.entries(data_set.time_series.interval_data);
    dataArray.forEach(function(ts){
        var thisDate = new Date(ts.key);

        if (thisDate >= startDate && thisDate <= endDate) {
            //console.log("thisDate: " + thisDate);
            //console.log(ts.key);

            //Load in VITs from this time interval.
            if (data_set.time_series.interval_data[ts.key].hasOwnProperty("tweets_vit")){
                data_set.time_series.interval_data[ts.key].tweets_vit.forEach(function(tweet){
                    //console.log(tweet.tweet_url.split('/')[5]);
                    if (tweetIDs.length <= tweet_vit_limit) {
                        tweetIDs.push(tweet.tweet_url.split('/')[5]);
                    }
                });    
            
            }    
        } 
    });
        
    //console.log(tweetIDs);

    // remove tweet, tweet list, and photo
    d3.select("#tweets_vit").selectAll('*').remove();
    d3.select("#tweet_from_map").selectAll('*').remove();
    d3.select('#photo').remove();

    tweetIDs.forEach(function(tweetID,i){
        // create new element
        d3.select("#tweets_vit")
          .append("div")
          .attr("id","tweet"+i)
          .classed("tweetList",true);
        // embed new tweet
        twttr.widgets.createTweet(
        tweetID,
        document.getElementById('tweet'+i)
        );
    })
}

//---------------------------------------------------------------------------------
// Time-series plots and event time controls.

function animate() {
    console.log("Animate!"); 

    var extent = brush.extent();
    console.log('extent: ' + extent);

    var startTime = new Date(extent[0]);
    var endTime = new Date(extent[1]);

    var span = endTime - startTime;

    //determine span of brush 
    console.log("time span: " + span/1000/60/60 + " hours.");

    //Advance brush extents. While checking if we are at end. If so, toggle button.

    //loop through time intervals

    var dataSetEndTime = new Date("2013-09-18 00:00:00"); //TODO: this needs to be 'dynamic'.

    console.log("dataSetEndTime: " + dataSetEndTime);
    console.log("endTime: " + endTime);

    while (endTime < dataSetEndTime) {
        console.log("in animation loop");
        //startTime = startTime + span;
        //endTime = endTime + span;
        startTime = d3.time.hour.offset(startTime,Math.round(span / 3600 /1000 ));
        endTime = d3.time.hour.offset(endTime,Math.round(span / 3600 /1000 ));
        console.log("new startTime: " + startTime);
        console.log("new endTime: " + endTime);
        
        drawBrush(startTime, endTime);
    }
}

function playButton(svg, x, y) {
  var i = 0;
  var playing = 0;
  
  var button = svg.append("g")
      .attr("transform", "translate("+ x +","+ y +")");

  button
    .append("rect")
      .attr("width", 90)
      .attr("height", 50)
      .attr("rx", 4)
      .style("fill", "steelblue");

  button
    .append("path")
      //.attr("d", "M15 10 L15 40 L35 25 Z")
      .attr("d", "M15 10 L15 40 L75 25 Z")
      .style("fill", "white");
     
  button
      .on("mousedown", function() {
        
        if (playing == 0) {
            console.log("Playing!");
            playing = 1;

            animate();

        } else {
            console.log("Paused.");
            playing = 0;
        }

        d3.select(this).select("rect")
            .style("fill","white")
            .transition().style("fill","steelblue");
      });
}

function drawBrush(startTime, endTime) {
    // our year will this.innerText
    console.log("drawBush");

    console.log("new startTime: " + startTime);  
    console.log("new endTime: " + endTime);


    // define our brush extent to be begin and end of the year
    brush.extent([startTime, endTime]);

    // now draw the brush to match our extent
    // use transition to slow it down so we can see what is happening
    // remove transition so just d3.select(".brush") to just draw
    brush(d3.select(".brush").transition().duration(4000));

    // now fire the brushstart, brushmove, and brushend events
    // remove transition so just d3.select(".brush") to just draw
    brush.event(d3.select(".brush").transition().delay(5000))

    brushed(timeseries1);
}


function convert_to_array(data, tag){

    // to iterate, we transform the object to array
    var dataArray = d3.entries(data.time_series.interval_data);

    // function for parsing dates
    var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S").parse;

    // parse dates and coerce values
    function iterate_(dataArray){
        parsedDataArray = [];
        dataArray.forEach(function(ts) {

             // create timeseries data
            if (ts.value.stats.hasOwnProperty(tag)){
                console.log()
                var count = +ts.value.stats[tag]
            }else{
                var count = +0
            }
            parsedDataArray.push({
              key:parseDate(ts.key)
              , value:count
            });
        });
        return parsedDataArray.sort(function(a,b){
            return b.key-a.key
        });
    }
    return iterate_(dataArray);
}


//--------------------------------------------------------------------

//Ready, set, go from here...



d3.json("data/event_viewer.json", function(collection) { //Load JSON dataset
    //console.log(["collection:",collection])
    data_set = collection;

    // all sizes
    var sizes = set_sizes();

    // build map and create an svg.
    var map = build_map();

    // build timeseries
    timeseries1 = convert_to_array(collection,"tweets");
    var timeseries2 = convert_to_array(collection,"tweets_geo_with_media");
    
    //console.log("timeseries1: " + timeseries1);
    //console.log("timeseries2: " + timeseries2);
    create_timeseries_plot(timeseries1, timeseries2, sizes);

    // add point to map
    add_points_to_map(collection,map);

    // Adjust map & tweet orientation when window is resized.
    window.addEventListener('resize', function(event){
        //set_values(timeseriesData,dateParsed);
        var sizes = set_sizes();
        create_timeseries_plot(timeseries1, timeseries2, sizes);
    });

    // Mouseover event that produces embeded tweet
    var circles = d3.selectAll(".tweet_location")
    circles.on("mouseover",function(event){
        // removes the border on the tweet list
        d3.select("#tweets_vit")
          .style('border',null);

        // removes old embeded tweet and tweet list
        var element = d3.select(this)
        d3.select("#tweet_from_map").selectAll('*').remove();

        // remove old photo
        d3.select('#photo').remove();

        // adds new embeded tweet
        twttr.widgets.createTweet(
            element.attr('tweetID'),
            document.getElementById('tweet_from_map')
        );

        // add new photo
        console.log(["element.attr('mediaURL'):",element.attr("mediaURL")])
        if (element.attr("mediaURL") != null){
            var photoURL = element.attr("mediaURL")
            if (photoURL.match("instagram.com") != null){
                    // embeds instagram photo
                    d3.select("body").append('img').attr('id','photo')
                      .attr('src','http://instagram.com/p/' + photoURL.split('/')[4] +'/media/?size=l')
                      .attr('border','2px solid')
                      .attr('border-radius','25px');
                }
        }
        var sizes = set_sizes();

    });
});