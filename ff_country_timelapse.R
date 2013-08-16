ff_country_timelapse = function() {
  # Read in libraries
  library(plyr);
  library(ez);
  library(rgeos);
  library(maptools);
  library(gpclib);
  
  # Read in data
  ff_by_country = read.csv("final_updated.csv");
  world = readShapeSpatial("World_countries_shp.shp");
  
  # Fix spelling differences between dataset and shape file
   for (country in world$NAME){
     match = 0;
     for (country_df in ff_by_country$Country)
     {
       if (toString(country) == toString(country_df)){
         match = 1;
       }
     }
     if (match != 1){
       print (country);
     }
   }
   
   # Create chloropleth
   library(ggplot2);
   library(animation);
   world = fortify(world, region="NAME");
  
    saveGIF({
      for (i in 1:61){
        row = paste("X",i,sep="")
        title = paste("Market Share of Firefox by country ",i,sep="")
        map = ggplot() + geom_map(data=ff_by_country, aes_string(map_id='Country', fill=row), map=world) + expand_limits(x=world$long, y=world$lat) + scale_fill_gradient2(name="Market Share", space="Lab", na.value=NA, limits=c(0,100)) + ggtitle(title)+ theme(plot.title = element_text(lineheight=.8, face="bold",size=20));
      }  
    }, interval=0.5, movie.name="ggplot2-ff-market-share.gif",ani.width=800, ani.height=800)

}
