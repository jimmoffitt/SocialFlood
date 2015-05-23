/*************************************
//
// flood-socket app
//
**************************************/

/*

TO-DOs:
-------
[] Scanning array for matching string.
[] Scripts for launching different socket demos: globe, flood replay, and real-time. Text-based, semi-unfiltered Replay?
*/


'use strict';

// Connect to our socket server.
var socket = io.connect('http://127.0.0.1:7008/');

//Set-up some common vars =======================


//Sizing things.
var width = window.innerWidth; // default width
var height = window.innerHeight; // default height

//Summary at top.
var summaryHeight = height * 0.10;
var summaryWidth = width;
var tweet_id = 0;
var tweetCount = 0;
var tweetTime = '';

//First verion had a simple scrolling log of Tweet bodies. Hopefully we won't be going back there...
//var log_text = '';
//var tweetlogHeight = 0.8 * height;
//var tweetlogWidth = 0.6 * width;    

var svg = d3.select('#summary').append('svg')
    .attr('width', width )
    .attr('height', height * 0.30);

var data_container = svg.append('g').classed('data_container', true);

// build data text on top right of screen
data_container.append('text')
  .attr('id','tweetcounttext')
  .attr('dy', 50)
  .attr('dx', width * 0.3)
  .text('Total Tweets: 0');

data_container.append('text')
  .attr('id','tweettime')
  .attr('dy', 90)
  .attr('dx', width * 0.3)
  .text('Tweet time: YYYY-MM-DD HH:MM');  


//Three columns with Tweets. Tweets will be in a 'div' array, and we'll keep a given amount of those (100?).
//So, these counters are used to provide divs with unique IDs.
var maxTweetsInColumn = 40;
var tweetCol1Count = 0, tweetCol2Count = 0, tweetCol3Count = 0, tweetCol4Count = 0;
var tweetCol1Divs = 0, tweetCol2Divs = 0, tweetCol3Divs = 0, tweetCol4Divs = 0;

d3.select("#tweets_column1")
  .classed("tweets_column1",true);

d3.select("#tweets_column2")
  .classed("tweets_column2",true);

d3.select("#tweets_column3")
  .classed("tweets_column3",true);

d3.select("#tweets_column4")
  .classed("tweets_column4",true);

//TODO: need to put sizing in a method and call that.
// set hieights based on window size.
window.onresize = function () {
  width = window.innerWidth; // default width
  height = window.innerHeight; // default height
  svg.attr('width', width)
    .attr('height', height * 0.20);

  data_container.attr('dx', width * 0.5);
  d3.select("#tweetcounttext").attr('dx', width * 0.3);
  d3.select("#tweettime").attr('dx', width * 0.3);
};

function handleTweet(tweet) {

  tweet_id = tweet.id.split(':')[2];
  tweetCount += 1;
  tweetTime = tweet.postedTime;

  //document.getElementById("tweetlog").style.margin = "0px 25px";
  //log_text = '<br>' + tweet.body + '</br>' + document.getElementById('tweetlog').innerHTML;
  //log_text = log_text.substring(0,10000);   
  //eZdocument.getElementById('tweetlog').innerHTML = log_text;

  d3.select('#tweetcounttext').text('Total Tweets: ' + tweetCount);
  d3.select('#tweettime').text('Tweet time: ' + tweetTime);
  
  //TODO: Drop Tweets with certain words.
  if (tweet.body.indexOf("fuck") > 0 || tweet.body.indexOf("shit") > 0 ) {
    console.log("A bit of language scrubing..");
    return;
  }

  //console.log(tweet.gnip.matching_rules[0].value);
  //if (tweet.gnip.matching_rules[0].tag.indexOf("has_media") > 0) {
  //  console.log("HAS MEDIA !!!!!!!!! WOO WOO!!!!!!! ");
  //}

  //Filter Tweets and assign them to a column.

  //Column 1 - Select local agencies.

  if (tweet.gnip.matching_rules[0].tag.indexOf("agency") >= 0 ) {
    
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
  else if (tweet.gnip.matching_rules[0].tag.indexOf("media") >= 0 ) {

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
  else if (tweet.gnip.matching_rules[0].tag.indexOf("flood_tag") >= 0 ) {

    tweetCol3Divs = tweetCol3Divs + 1;

    d3.select("#tweets_column3")
      .insert("div", "#col3_" + (tweetCol3Divs-1))
      .attr('id',"col3_" + tweetCol3Divs)
      .classed("tweets_column3", true);

    twttr.widgets.createTweet(
      tweet_id,
      document.getElementById("col3_" + tweetCol2Divs)
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

socket.on('tweet', handleTweet);
