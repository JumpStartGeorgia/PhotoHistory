var not_published = false;
var pairing_dt;
$(document).ready(function(){
  var value = getParameterByName('not_published');
  if (value == "true"){
    not_published = true;
  }

  $.extend( $.fn.dataTableExt.oStdClasses, {
      "sWrapper": "dataTables_wrapper form-inline"
  });

  $('#images-datatable').dataTable({
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",    
    "sPaginationType": "bootstrap",
    "bJQueryUI": true,
    "bProcessing": true,
    "bServerSide": true,
    "bDestroy": true,
    "bAutoWidth": false,
    "sAjaxSource": $('#images-datatable').data('source'),
    "oLanguage": {
      "sUrl": gon.datatable_i18n_url
    },
    "aoColumnDefs": [
      { 'bSortable': false, 'aTargets': [ 7,8 ] }
    ],
    "aaSorting": [[9, 'desc']]
  });

  pairing_dt = $('#pairings-datatable').dataTable({
//    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",    
    "sDom": "<'row-fluid'<'span5'l><'span5'f><'span2'<'#not_published_button'>>r>t<'row-fluid'<'span6'i><'span6'p>>",    
    "sPaginationType": "bootstrap",
    "bJQueryUI": true,
    "bProcessing": true,
    "bServerSide": true,
    "bDestroy": true,
    "bAutoWidth": false,
    "sAjaxSource": $('#pairings-datatable').data('source'),
    "oLanguage": {
      "sUrl": gon.datatable_i18n_url
    },
    "aaSorting": [[4, 'desc']],
    "fnServerParams": function ( aoData ) {
      aoData.push( { name: "not_published", value: not_published} );
    }
  });

  // add the published button to the header
  function load_html_into_button ()
  {
    if ($("div#not_published_button").length)
      $("div#not_published_button").html($('#hidden_not_published_button').html());
    else
      setTimeout(load_html_into_button, 25);
  }
  load_html_into_button();

  // select all checkboxes
  $('a#select_all_unpublished').click(function(){
    $('input', pairing_dt.fnGetNodes()).attr('checked', 'checked');
  });

  $('#categories-datatable').dataTable({
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",    
    "sPaginationType": "bootstrap",
    "bJQueryUI": true,
    "bProcessing": true,
    "bServerSide": true,
    "bDestroy": true,
    "bAutoWidth": false,
    "sAjaxSource": $('#categories-datatable').data('source'),
    "oLanguage": {
      "sUrl": gon.datatable_i18n_url
    },
    "aaSorting": [[3, 'desc']]
  });

  $('#users-datatable').dataTable({
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",    
    "sPaginationType": "bootstrap",
    "bJQueryUI": true,
    "bProcessing": true,
    "bServerSide": true,
    "bDestroy": true,
    "bAutoWidth": false,
    "sAjaxSource": $('#users-datatable').data('source'),
    "oLanguage": {
      "sUrl": gon.datatable_i18n_url
    },
    "aaSorting": [[2, 'desc']]
  });


});
