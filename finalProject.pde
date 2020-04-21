// Diego Valdez and Patrick Seminatore
// CPSC 313

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
    Location USAlocation = new Location(39.8f, -98.58f);
    float maxPanningDistance = 0;
    size(800, 600);
    map = new UnfoldingMap(this);
    map.zoomAndPanTo(USAlocation, 4);
    MapUtils.createDefaultEventDispatcher(this, map);
    map.setPanningRestriction(USAlocation, maxPanningDistance);
    map.setZoomRange(3, 4);
}

void draw() {
    map.draw();
    Location location = map.getLocation(mouseX, mouseY);
    fill(0);
    text(location.getLat() + ", " + location.getLon(), mouseX, mouseY);
}
