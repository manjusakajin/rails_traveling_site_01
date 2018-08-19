var map;
var jsonObj = [];
var image = 'https://image.ibb.co/mgYSWU/Screenshot_from_2018_08_14_14_54_04.png';
var stat=false;

function initMap() {
  map = new google.maps.Map(document.getElementById('map-show-trip'), {
    zoom: 12,
    center: {lat: 21, lng: 105.8}
  });

  var directionsService = new google.maps.DirectionsService;
  var directionsDisplay = new google.maps.DirectionsRenderer({
    draggable: false,
    map: map,
    panel: document.getElementById('right-panel')
  });

  directionsDisplay.addListener('directions_changed', function() {
    computeTotalDistance(directionsDisplay.getDirections());
  });
  var origin = document.getElementById('origin').value;
  var destination = document.getElementById('destination').value;

  displayRoute(origin, destination, directionsService,
      directionsDisplay);
  var geocoder_origin = new google.maps.Geocoder();
  var geocoder_destination = new google.maps.Geocoder();
  geocodeAddress(geocoder_origin, origin, 'Start', 0);
  geocodeAddress(geocoder_destination, destination, 'Destination', 0);

  elements = Array.prototype.slice.call(document.getElementsByClassName('plant-places'));
  contentString = [];
  for (i = 0; i < elements.length; i++) {
    item = {};
    item['location'] = elements[i].value;
    jsonObj.push(item);
    contentString[i] = elements[i].value;
    geocoder = new google.maps.Geocoder();
    // plant_name = elements[i].getAttribute('data-name');
    plant_des = elements[i].getAttribute('data-des');
    plant_id = elements[i].getAttribute('data-id');
    geocodeAddress(geocoder, elements[i].value, plant_des, plant_id);
  }
  new AutocompleteDirectionsHandler(map);
}

function geocodeAddress(geocoder, address, plant_des, plant_id) {
  geocoder.geocode({'address': address}, function(results, status) {
    if (status === 'OK') {
      var marker = new google.maps.Marker({
        map: map,
        position: results[0].geometry.location,
        icon: image
      });
      var infowindow = new google.maps.InfoWindow({
        content: plant_des
      });
      infowindow.open(map, marker);
      google.maps.event.addListener(infowindow, 'closeclick', function() {
        document.getElementById(plant_id).click();
      });
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
}

function displayRoute(origin, destination, service, display) {
  service.route({
    origin: origin,
    destination: destination,
    waypoints: jsonObj,
    travelMode: 'DRIVING',
    avoidTolls: true
  }, function(response, status) {
    if (status === 'OK') {
      display.setDirections(response);
    } else {
      alert('Could not display directions due to: ' + status);
    }
  });
}

function computeTotalDistance(result) {
  var total = 0;
  var myroute = result.routes[0];
  for (var i = 0; i < myroute.legs.length; i++) {
    total += myroute.legs[i].distance.value;
  }
  total = total / 1000;
  document.getElementById('total').innerHTML = total + ' km';
}

function AutocompleteDirectionsHandler(map) {
  this.map = map;
  this.originPlaceId = null;
  var destinationInput = document.getElementById('place-input');

  var destinationAutocomplete = new google.maps.places.Autocomplete(
      destinationInput, {placeIdOnly: true});
  this.setupPlaceChangedListener(destinationAutocomplete, 'DEST');
}

AutocompleteDirectionsHandler.prototype.setupPlaceChangedListener = function(autocomplete, mode) {
  var me = this;
  autocomplete.bindTo('bounds', this.map);
  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.place_id) {
      window.alert('Please select an option from the dropdown list.');
      return;
    }
    me.destinationPlaceId = place.place_id;
    stat = true;
    var service = new google.maps.places.PlacesService(map);
    service.getDetails({
        placeId: place.place_id
    }, function (result, status) {
        var marker = new google.maps.Marker({
            map: map,
            place: {
                placeId: place.place_id,
                location: result.geometry.location
            }
        });
    });
  });
};
$(document).ready(function () {
  $('#new_plant').submit(function(event){
    if (!stat){
      alert('Location not found!: ' + status);
      return false;
    };
  });
})
