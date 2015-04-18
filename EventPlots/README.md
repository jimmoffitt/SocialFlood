# EventPlots

Big picture: Replay twitter events to explore relevant geographic information as the conversation unfolds.    

This project: sample code for building event plots.

#### Notes
+ First verion is an example of a static stack of line plots (see below).
  + Plots are drawn once as part of an event summary view, presentation mode.

+ Next versions need:
  + Dynamic resizing
  + Re-synch with latest EventBinner output. (and make easier to do next time?)  



  ![](https://raw.githubusercontent.com/jimmoffitt/SocialFlood/master/EventPlots/output/eventPlots_v1.png)



## Process:
1. Talk about the final viz, collect data, talk about the final viz, format  
data, talk about the final viz, add 3rd party data, reformat data, ...  

2. Review resources.  
+ JavaScript <-- This project is a pretty thin html/js wrapper for D3.
+ D3  <-- ```<script src="http://d3js.org/d3.v3.min.js"</script>```

3. Build a [line graph](http://bl.ocks.org/mbostock/3883245) 
4. Create a set of plot: 

5. Start leaning about 'plot' events: 
 - [Line graph tooltip] (http://bl.ocks.org/d3noob/e5daff57a04c2639125e) 

6. Ideas for next iterations:
    = Controls for navigating stacked plots with point pop-up display.
