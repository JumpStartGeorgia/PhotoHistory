$(document).ready(function(){
  function show_category_ancestry(val){
    if (gon.category_district && gon.category_district == val){
      $('form.category div#category_ancestry_input').show();
    }else{
      $('form.category div#category_ancestry_input').hide();
    }
  }
  
  $('form.category select#category_type_id').change(function(){
    show_category_ancestry($(this).val());
  });

  if ($('form.category select#category_type_id').length > 0){
    show_category_ancestry($('form.category select#category_type_id').val());
  }


});
