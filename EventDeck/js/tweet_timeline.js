/*************************************
//
// flood-socket app
//
**************************************/

'use strict';

// Connect to our socket server.
var socket = io.connect('http://127.0.0.1:7008/');

//Set-up some common vars =======================

var maxTweetsInColumn = 40;

//Sizing things.
var width = window.innerWidth; // default width
var height = window.innerHeight; // default height
var summaryHeight = 60;
var summaryWidth = width;

//Summary at top. 
var summary_svg = d3.select('body').append('svg')
    .attr('width', width )
    .attr('height', summaryHeight);

var summary_container = summary_svg.append('g').classed('summary_container', true);

var tweet_id = 0;
var tweetCount = 0;
var tweetTime = '';
var tweetVelocity = 0;
var timeStamp = new Date();
var timeStampDisplay = new Date();
var timearray = [];
var timeDrop = new Date();

timeStamp.setDate(-4000);
timeStampDisplay.setDate(-4000);

//console.log(timeStamp);
//console.log('summaryHeight: ' + summaryHeight);

// build data text on top right of screen
summary_container.append('text')
  .attr('id','tweettime')
  .attr('dy', summaryHeight * 0.35)
  .attr('dx', 0)
  .style("font-size",30)
  .style("font-family","serif")
  .text('Tweet time: YYYY-MM-DD HH:MM');  

// build data text on top right of screen
summary_container.append('text')
  .attr('id','tweetcount')
  .attr('dy', summaryHeight * 0.35)
  .attr('dx', summaryWidth * 0.4)
  .style("font-size",30)
  .style("font-family","serif")
  .text('Total Tweets: 0');

summary_container.append('text')
  .attr('id','tweetvelocity')
  .attr('dy', summaryHeight * 0.35)
  .attr('dx', width * 0.6)
  .style("font-size",30)
  .style("font-family","serif")
  .text('Tweet Velocity (TPM): 0');


//Columns with Tweets. Tweets will be in a 'div' array, and we'll keep a given amount of those (50?).
//So, these counters are used to provide divs with unique IDs.

var tweetCol1Count = 0, tweetCol2Count = 0, tweetCol3Count = 0, tweetCol4Count = 0;
var tweetCol1Divs = 0, tweetCol2Divs = 0, tweetCol3Divs = 0, tweetCol4Divs = 0;

d3.select("#tweets_column1").classed("tweets_column1",true);
d3.select("#tweets_column2").classed("tweets_column2",true);
d3.select("#tweets_column3").classed("tweets_column3",true);
d3.select("#tweets_column4").classed("tweets_column4",true);

//TODO: need to put sizing in a method and call that.
// set hieights based on window size.
window.onresize = function () {

  console.log('window resize event.')
  width = window.innerWidth; // default width
  height = window.innerHeight; // default height

  summaryHeight = height * 0.2;
  summaryWidth = width;
 
 
 console.log("resize Summary!")
 d3.select('#tweettime')
  //.attr('dy', summaryHeight * 0.35)
  .attr('dx', 0);

  d3.select('#tweetcount')
  //.attr('dy', summaryHeight * 0.35)
  .attr('dx', summaryWidth * 0.4);

  d3.select('#tweetvelocity')
  //.attr('dy', summaryHeight * 0.35)
  .attr('dx', summaryWidth * 0.6);
 
};


/*
socket is nice enough to provide JSON tweet payload.
Here we inspect the AS rule tags and direct the tweet to a display column.
Here we have logic to maintain maxTweetsInColumn
Also do some stats.
*/
function handleTweet(tweet) {

  tweet_id = tweet.id.split(':')[2];
  console.log("tweet_id: " + tweet_id)
  tweetCount += 1;
 
  //t = Date.parse(tweet.postedTime);
  timeStamp = new Date( Date.parse(tweet.postedTime));

  if (timeStamp > timeStampDisplay) {
    tweetTime = timeStamp;
    timeStampDisplay = timeStamp;
    //console.log(timeStampDisplay);
  }

  timearray.push(timeStamp); //Adding this tweet's timestamp.
  //console.log("timeStamp: " + timeStamp);
  timeDrop = timeStamp.setMinutes(timeStamp.getMinutes() - 1);
  timeDrop = new Date(timeDrop);

  //console.log(timeDrop);
  //var testDate = new Date(timeDrop);
  //console.log(testDate);


  for (var i=0; i < timearray.length; i++) { 
    if (timearray[i] < timeDrop) {
      //console.log("timearray[" + i + "]:" + timearray[i]);
      //console.log("Time to drop:" + timeDrop);

      //Remove it.
      timearray.splice(i,1);
    }
  }

  tweetVelocity = timearray.length;

  //TODO - only update with 'later' times.
  d3.select('#tweettime').text('Tweet time: ' + tweetTime.toLocaleDateString() + ' ' + tweetTime.toLocaleTimeString());  
  d3.select('#tweetcount').text('Total Tweets: ' + tweetCount);
  d3.select('#tweetvelocity').text('Tweet Velocity (TPM): ' + tweetVelocity);
  
  //Drop Tweets with certain words.
  if (tweet.body.indexOf("fuck") > 0 || tweet.body.indexOf("shit") > 0 ) {
    console.log("A bit of language scrubing..");
    return;
  }
  
  //Filter Tweets and assign them to a column.
  var tags = '';
  //Filtering by tag? Prepare tag array for string matching.
  tweet.gnip.matching_rules.map ( function (rule) {
    tags = tags + rule.tag + ',';
  })
  
  //Column 1 - Select local agencies.

  if (tags.indexOf("agency") >= 0 ) {
    
    tweetCol1Divs = tweetCol1Divs + 1;

     d3.select("#tweets_column1")
       .insert("div", "#col1_" + (tweetCol1Divs-1))
      .attr('id',"col1_" + tweetCol1Divs)
      .classed("tweets_column1", true);

    twttr.widgets.createTweet(
  	   tweet_id,
  	   document.getElementById("col1_" + tweetCol1Divs)
    );

    //Check number of Tweets in column, and remove last one if 'full';
    tweetCol1Count = document.querySelectorAll('#tweets_column1 .tweets_column1').length;

    if (tweetCol1Count > maxTweetsInColumn) {
      //console.log("Time to remove Tweets from Column 1.");
       d3.selectAll("#col1_" + (tweetCol1Divs-maxTweetsInColumn)).remove();
    }
  } 

  //Column 2 - Select hashtags.
  else if (tags.indexOf("media") >= 0 ) {

    tweetCol2Divs = tweetCol2Divs + 1;

    d3.select("#tweets_column2")
      .insert("div", "#col2_" + (tweetCol2Divs-1))
      .attr('id',"col2_" + tweetCol2Divs)
      .classed("tweets_column2", true);

    twttr.widgets.createTweet(
      tweet_id,
      document.getElementById("col2_" + tweetCol2Divs)
    );

    //Check number of Tweets in column, and remove last one if 'full';
    tweetCol2Count = document.querySelectorAll('#tweets_column2 .tweets_column2').length;

    if (tweetCol2Count > maxTweetsInColumn) {
      d3.selectAll("#col2_" + (tweetCol2Divs-maxTweetsInColumn)).remove();
    }
  }
  //Column 3 - has Media.
  else if (tags.indexOf("flood_tag") >= 0 ) {

    tweetCol3Divs = tweetCol3Divs + 1;

    d3.select("#tweets_column3")
      .insert("div", "#col3_" + (tweetCol3Divs-1))
      .attr('id',"col3_" + tweetCol3Divs)
      .classed("tweets_column3", true);

    twttr.widgets.createTweet(
      tweet_id,
      document.getElementById("col3_" + tweetCol3Divs)
    );

    //Check number of Tweets in column, and remove last one if 'full';
    tweetCol3Count = document.querySelectorAll('#tweets_column3 .tweets_column3').length;

    if (tweetCol3Count > maxTweetsInColumn) {
      d3.selectAll("#col3_" + (tweetCol3Divs-maxTweetsInColumn)).remove();
    }
  }

  //Column 4 - Everything else.
  else { 

    tweetCol4Divs = tweetCol4Divs + 1;

    d3.select("#tweets_column4")
      .insert("div", "#col4_" + (tweetCol4Divs-1))
      .attr("id", "col4_" + tweetCol4Divs)
      .classed("tweets_column4", true);

    twttr.widgets.createTweet(
        tweet_id,
        document.getElementById("col4_" + tweetCol4Divs)
    );

    //Check number of Tweets in column, and remove last one if 'full';
    tweetCol4Count = document.querySelectorAll('#tweets_column4 .tweets_column4').length;

    if (tweetCol4Count > maxTweetsInColumn) {
      d3.selectAll("#col4_" + (tweetCol4Divs-maxTweetsInColumn)).remove();
    }
  }
}

//----------------------------------

socket.on('tweet', handleTweet); //Tweet arrived, go handle it!
