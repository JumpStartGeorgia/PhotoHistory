$(function()
{
/*

  var cloudmade = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {maxZoom: 18, attribution: ''});

  var map = new L.map('map');
  map.setView(new L.LatLng(lat, lon), 14).addLayer(cloudmade);

  var marker = new L.Marker(new L.LatLng(lat, lon));
  map.addLayer(marker);
*/
});


if ('lat' in gon && 'lon' in gon)
{
  var lat = gon.lat;
  var lon = gon.lon;
}
else
{
  var lat = 41.697760228187086;
  var lon = 44.79820936918259;
}
var center = new google.maps.LatLng(lat, lon);
var map = 1;

function initialize ()
{
  var mapCanvas = document.getElementById('map');
  var mapOptions = {
    center: center,
    zoom: 19,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(mapCanvas, mapOptions);

  addMarker({position: center});
}


var iconBase = 'https://maps.google.com/mapfiles/kml/shapes/';
var icon = {
  icon: iconBase + 'info-i_maps.png',
  shadow: iconBase + 'info-i_maps.shadow.png'
};

function addMarker (feature)
{
  var marker = new google.maps.Marker(
  {
    position: feature.position,
    icon: icon.icon,
    shadow: {
      url: icon.shadow,
      anchor: new google.maps.Point(16, 34)
    },
    map: map
  });
}

google.maps.event.addDomListener(window, 'load', initialize);




