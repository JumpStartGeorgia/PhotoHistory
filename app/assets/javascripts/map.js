$(function()
{
  if ('lat' in gon && 'lon' in gon){
//		var map = new L.Map(gon.map_id).setView(new L.LatLng(gon.lat, gon.lon), gon.zoom);

//    L.tileLayer(gon.tile_url, {maxZoom: gon.max_zoom}).addTo(map);      

    var map = new L.map(gon.map_id, {
        center: new L.LatLng(gon.lat, gon.lon),
        zoom: gon.zoom,
        maxZoom: gon.max_zoom,
        layers: new L.TileLayer(gon.tile_url)
    });


    var customIcon = L.icon({
        iconUrl: '/assets/map_icon.png',
        iconSize:     [27, 27], // size of the icon
        popupAnchor:  [0, -10] // point from which the popup should open relative to the iconAnchor
    });


    var marker = L.marker(new L.LatLng(gon.lat, gon.lon), {icon: customIcon}).addTo(map)
    if ('map_marker_text' in gon){
        marker.bindPopup(gon.map_marker_text)
        .openPopup();
    }
  } else if ('edit_image_file' in gon && 'edit_lat' in gon && 'edit_lon' in gon){
    // continue to use open street maps for editing

		var map = new L.Map(gon.edit_map_id).setView(new L.LatLng(gon.edit_lat, gon.edit_lon), gon.edit_zoom);

    L.tileLayer(gon.edit_tile_url, {maxZoom: gon.max_zoom}).addTo(map);      

    var marker = L.marker(new L.LatLng(gon.edit_lat, gon.edit_lon)).addTo(map);
    marker.dragging.enable();
    marker.on('dragend', function (e) {
        coords = e.target.getLatLng();
        $('#image_file_lat').attr('value', coords.lat);
        $('#image_file_lon').attr('value', coords.lng);
        $('#image_file1_lat').attr('value', coords.lat);
        $('#image_file1_lon').attr('value', coords.lng);
    });
  }
});


