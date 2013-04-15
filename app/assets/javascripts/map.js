$(function()
{
  if ('lat' in gon && 'lon' in gon && 'map_marker_text' in gon){
    // create map
		var map = new L.Map(gon.map_id).setView(new L.LatLng(gon.lat, gon.lon), gon.zoom);

    L.tileLayer(gon.tile_url, {maxZoom: gon.max_zoom}).addTo(map);      
    L.marker(new L.LatLng(gon.lat, gon.lon)).addTo(map)
      .bindPopup(gon.map_marker_text)
      .openPopup();
  }
});


