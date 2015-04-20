
//==============================================================================
var numPlots = 7

// Parse the date / time
var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S").parse;

//==============================================================================

function redraw(dataArray) {


 /*   
    // Set the dimensions of the canvas / graph
    var margin = {top: 30, right: 20, bottom: 30, left: 50};
    var plotWidth = (window.innerWidth * 0.8) - margin.left - margin.right;
    var plotHeight = (window.innerHeight * 0.8)/numPlots - margin.top - margin.bottom;

    // Set the ranges
    var x = d3.time.scale().range([0, plotWidth]);
    var y = d3.scale.linear().range([plotHeight, 0]);

    // Define the axes
    var xAxis = d3.svg.axis()
        .scale(x)
        .ticks(5)
        .tickFormat(d3.time.format("%b %d"))
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left").ticks(5);

    // Define the line
    var valueline = d3.svg.line()
        .x(function(d) { return x(d.key); })
        .y(function(d) { return y(d.value); });

*/

    /*
    d3.select("#plots")
        .attr('width',Width)
        .attr('height',plotsHeight);
    */

    draw_plots(dataArray)

}

function draw_plots(dataArray) {

    d3.select("#plot0").selectAll("*").remove();
    d3.select("#plot1").selectAll("*").remove();
    d3.select("#plot2").selectAll("*").remove();
    d3.select("#plot3").selectAll("*").remove();
    d3.select("#plot4").selectAll("*").remove();
    d3.select("#plot5").selectAll("*").remove();
    d3.select("#plot6").selectAll("*").remove();

    //Twitter data -------------------------------------------------------

    //Tweet data (stored in GeoJSON) //<interval>.tweet_geo.features.count
    var data = create_tweet_data(dataArray);  
    var plot = make_plot(d3.select("#plot0"),data,"Geo-tagged Tweets with media","steelblue");

    //Twitter event stats. //<interval>.stats.hashtags[hashtag]
    var data = create_hashtag_data(dataArray, "*flood"); 
    var plot = make_plot(d3.select("#plot1"),data,"#flood","green");

    var data = create_hashtag_data(dataArray, "boulderflood");
    var plot = make_plot(d3.select("#plot2"),data,"#BoulderFlood","green");

    var data = create_hashtag_data(dataArray, "longmontflood");
    var plot = make_plot(d3.select("#plot3"),data,"#LongmontFlood","green");

    //External data --------------------------------------------------------
    //Current use-case: rain and river-level data. 

    //Rain accumulation data for single sites: //<interval>.rain[Site].accumulation
    var data = create_rain_data(dataArray, "boulder_jail");
    var plot = make_plot(d3.select("#plot4"),data,"Boulder Jail Rain","blue");

    //Stage data for single sites: //<interval>.stage[Site].stage
    var data = create_stage_data(dataArray, "Broadway");
    var plot = make_plot(d3.select("#plot5"),data,"Broadway Stage","orange");

    var data = create_stage_data(dataArray, "Fourmile");
    var plot = make_plot(d3.select("#plot6"),data,"Fourmile Stage","orange");

}

//==============================================================================

function make_plot(div, data, label, color) {


    // Set the dimensions of the canvas / graph
    //var margin = {top: 30, right: 20, bottom: 30, left: 50};
    var margin = {top: window.innerHeight*0.03, right: window.innerWidth*0.05, bottom: window.innerHeight*0.04, left: window.innerWidth*0.05};
    //var margin = {top: 25, right: 20, bottom: 25, left: 50};
    
    var plotWidth = (window.innerWidth * 0.8) - margin.left - margin.right;
    //var plotHeight = ((window.innerHeight * 0.8) - margin.top - margin.bottom) / numPlots;
    //var plotHeight = ((window.innerHeight * 0.7) - margin.top - margin.bottom ) / numPlots;
    var plotHeight = ((window.innerHeight * 0.8 ) / numPlots) - margin.top - margin.bottom;


    // Set the ranges
    var x = d3.time.scale().range([0, plotWidth]);
    var y = d3.scale.linear().range([plotHeight, 0]);

    // Define the axes
    var xAxis = d3.svg.axis()
        .scale(x)
        .ticks(5)
        .tickFormat(d3.time.format("%b %d"))
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left").ticks(5);

    // Define the line
    var valueline = d3.svg.line()
        .x(function(d) { return x(d.key); })
        .y(function(d) { return y(d.value); });

    plot = div         
        .append("svg")
            .attr("width", plotWidth + margin.left + margin.right)
            .attr("height", plotHeight + margin.top + margin.bottom)
        .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    data.forEach(function(d) {
        d.key = parseDate(d.key);
        d.value = +d.value;
    });

    // Scale the range of the data
    x.domain(d3.extent(data, function(d) { return d.key; }));
    y.domain([0, d3.max(data, function(d) { return d.value; })]);

    // Add the valueline path.
    plot.append("path")
        .attr("class", "line")
        .attr("d", valueline(data))
        .style("stroke",color);

    // Add the X Axis
    plot.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + plotHeight + ")")
        .call(xAxis);

    // Add the Y Axis
    plot.append("g")
        .attr("class", "y axis")
        .call(yAxis);

    /*
    plot.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text(label); 
    */   

    plot.append("text")
        .attr("x", (plotWidth / 20))             
        .attr("y", 0 - (margin.top / 5))
        .attr("text-anchor", "left")  
        .text(label);    

    return plot     

}




//==============================================================================

function create_tweet_data(dataArray){
    var data = {};
    dataArray.forEach(function(d,i){
        if (d.value.hasOwnProperty("tweets_geo")){
            data[d.key] = d.value.tweets_geo.features.length
            //data[d.key] = 0
        }else{
            data[d.key] = 0
        }
    })
    return d3.entries(data)
}

function create_hashtag_data(dataArray, hashtag){
    var data = {};
    dataArray.forEach(function(d,i){
    	data[d.key] = 0 //default
        if (d.value.hasOwnProperty("stats")){
        	if (d.value.stats.hasOwnProperty("hashtags")){
        		if (d.value.stats.hashtags.hasOwnProperty(hashtag)){
        			data[d.key] = d.value.stats.hashtags[hashtag]
        		}
        	}
        }
    })
    return d3.entries(data)
}

function create_rain_data(dataArray, site){
    var data = {};
    dataArray.forEach(function(d,i){
    	data[d.key] = 0 //default
        if (d.value.hasOwnProperty("rain")){
        	if (d.value.rain.hasOwnProperty(site)){
        		data[d.key] = d.value.rain[site].accumulation
        	}
        }
    })
    return d3.entries(data)
}

function create_stage_data(dataArray, site){
    var data = {};
    dataArray.forEach(function(d,i){
    	data[d.key] = 0 //default
        if (d.value.hasOwnProperty("stage")){
        	if (d.value.stage.hasOwnProperty(site)){
        		data[d.key] = d.value.stage[site].stage
        	}
        }
    })
    return d3.entries(data)
}


//-------------------------------------------------------------------   
console.log("Building event plots... ")
console.log("Getting data... ") // Get the data once.

//The Mother load of data, hosts both Twitter and 'external' data.
//Contains static metadata, time-series (hourly) data, and pre-baked stats.
//Time-series data is an object array with "YYYY-MM-DD HH:MM:SS" formatted keys.

d3.json("data/event_viewer.json", function(collection) {   

	var dataArray = d3.entries(collection.time_series.interval_data);

    redraw(dataArray)

    // Adjust map & tweet orientation when window is resized.
    window.addEventListener('resize', function(event){
        console.log("redrawing")
        redraw(dataArray);
     });

});
