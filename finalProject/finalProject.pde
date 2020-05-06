// Diego Valdez, Patrick Seminatore, Thomas McDonald
// CPSC 313

// # TODO -- $$$Read in data$$$$, $$$$create color scale$$$$$$$$, $$$$color state by beer per year$$$$, make keys switch year, $$$make label$$$$

import java.util.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.utils.*;

Table beerData;
List<Feature> states;
List<Marker>stateMarkers;
UnfoldingMap map;
//DebugDisplay detailedViz;

int currentYear = 2011;

// Sets up the canvas and loads in the csv document
void setup() {
    map = new UnfoldingMap(this);
    map.setBackgroundColor(240);
    MapUtils.createDefaultEventDispatcher(this, map);
    Location USAlocation = new Location(39.8f, -98.58f);
    float maxPanningDistance = 0;
    size(1600, 1200, P2D);
    map.zoomAndPanTo(USAlocation, 5);
    MapUtils.createDefaultEventDispatcher(this, map);
    map.setPanningRestriction(USAlocation, maxPanningDistance);
    map.setZoomRange(4, 5);
    
    //detailedViz = new DebugDisplay(this, map, 10,10);
    
    // Load in beer data
    beerData = loadTable("beer_states.csv", "header");
    
    // Load in state data
    states = GeoJSONReader.loadData(this, "usStates.geo.json");
    stateMarkers = MapUtils.createSimpleMarkers(states);
    map.addMarkers(stateMarkers);
    Iterable<TableRow> beerDataCurrentYear = beerData.findRows(Integer.toString(currentYear), "year");
    colorStates(states, beerDataCurrentYear);

}




void draw() {
    map.draw();
    Location location = map.getLocation(mouseX, mouseY);
    fill(0,0,0);
    textSize(12);
    text(location.getLat() + ", " + location.getLon(), mouseX, mouseY);
    textSize(48);
    text(currentYear, 704.0, 100.0);
    
}

// Need to figure out a color scheme so that no two colors are adjacent
void colorStates(List<Feature> states, Iterable<TableRow> stateBeerCurrentYear){
    float maxBeer = findMax();
    for (Marker marker : stateMarkers){
      String stateName = marker.getStringProperty("name"); //<>//
      if (!stateName.equals("total")){
        float currentStateBeer = findTotalBarrels(stateBeerCurrentYear, stateName);
        float scaledColor = scaleColor(maxBeer, currentStateBeer);
        marker.setColor(color(255, scaledColor, scaledColor));
      }
    } //<>//
}


// There are 3 different types of production listed per year for each state 
// This method sums and returns all 3 for a given state
float findTotalBarrels(Iterable<TableRow> stateBeerCurrentYear, String state){
  float totalBarrels = 0; //<>//
  for (TableRow row : stateBeerCurrentYear){
     String temp = row.getString("state");
     if (temp.equals(state)){
       totalBarrels += row.getFloat("barrels"); 
     }
  }
  return totalBarrels;
}

float findMax(){
    float maxBeer = 0;
    for (int i = 2008; i < 2020; i++){
        Iterable<TableRow> stateBeerCurrentYear = beerData.findRows(Integer.toString(i), "year");
        for (TableRow row : stateBeerCurrentYear){
        if (!row.getString("state").equals("total")){
          float currentBeer;
          try{
             currentBeer = findTotalBarrels(stateBeerCurrentYear, row.getString("state"));
          } catch (Exception e){
            currentBeer = 0;
          }
          if (currentBeer > maxBeer){
             maxBeer = currentBeer;
          }
        }
     }    
    }
     return maxBeer;
}

float scaleColor(float maxBeer, float currentStateBeer){
    float scaledColor = 0;
    if (!Float.isNaN(currentStateBeer)){
      scaledColor = map((float)Math.cbrt(currentStateBeer), 0.0, (float)Math.cbrt(maxBeer), 0.0, 255.0);
    }
    
    return 255 - scaledColor;
}

public void mouseClicked() {
    Location mouseLocation = map.getLocation(mouseX, mouseY);
    List<Marker>stateMarkers = MapUtils.createSimpleMarkers(states);
    MarkerManager<Marker> stateManager = new MarkerManager<Marker>();
    stateManager.addMarkers(stateMarkers);
    Marker selectedMarker = map.getFirstHitMarker(mouseX, mouseY);
    for (Marker marker : map.getMarkers()) {
            marker.setStrokeWeight(1);
            marker.setSelected(false);
        }
    if (selectedMarker != null) {
       selectedMarker.setStrokeWeight(4);
       selectedMarker.setSelected(true);
    }
}

// Changes the year based on arrow pressed
void keyPressed(){
  if (key == CODED){
    if (keyCode == LEFT){
      if (currentYear == 2008){
        currentYear = 2019;
        Iterable<TableRow> beerDataCurrentYear = beerData.findRows(Integer.toString(currentYear), "year");
        colorStates(states, beerDataCurrentYear);
      }
      else currentYear -= 1;
    }
    else if (keyCode == RIGHT){
      if (currentYear == 2019){
        currentYear = 2008;
        Iterable<TableRow> beerDataCurrentYear = beerData.findRows(Integer.toString(currentYear), "year");
        colorStates(states, beerDataCurrentYear);
      }
      else currentYear +=1;
    }
  }
}
