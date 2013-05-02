$(function ()
{

  $('#images-table').dataTable({
    bJQueryUI: true,
    bProcessing: true,
    bServerSide: true,
    sAjaxSource: $('#images-table').data('source')
  });

});
