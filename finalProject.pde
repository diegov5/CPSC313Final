// Diego Valdez and Patrick Seminatore
// CPSC 313

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
UnfoldingMap map;

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
    //map.setPanningRestriction(USAlocation, maxPanningDistance);
    map.setZoomRange(1, 5);
    
    List<Feature> states = GeoJSONReader.loadData(this, "usStates.geo.json");
    System.out.println(states.size());
    List<Marker>stateMarkers = MapUtils.createSimpleMarkers(states);
    map.addMarkers(stateMarkers);
    colorStates(stateMarkers);

}


// Need to figure out a color scheme so that no two colors are adjacent
void colorStates(List<Marker> stateMarkers){
    int colorNum = 0;
    for (Marker marker : stateMarkers){
       if (colorNum == 0){
         marker.setColor(color(255, 0, 0));
         colorNum++;
       }
       else if (colorNum == 1){
         marker.setColor(color(0, 255, 0));
         colorNum++;
       }
       else if (colorNum == 2){
         marker.setColor(color(0, 0, 255));
         colorNum++;
       }
       else if (colorNum == 3){
         marker.setColor(color(230, 230, 0));
         colorNum = 0;
       }
    }
}

void draw() {
    map.draw();
    Location location = map.getLocation(mouseX, mouseY);
    fill(0,0,0);
    text(location.getLat() + ", " + location.getLon(), mouseX, mouseY);
}
