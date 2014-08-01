$(document).ready(function(){

  ///////// image file form
  // only show the options that are for the selected city
  // if none, hide districts
  function show_image_file_districts_for_city(val){
    if (val != '' && $('form.image_file select#image_file_district_id option[data-parent-id="' + val + '"]').length > 0){
      $('form.image_file select#image_file_district_id option').css('display:none;');
      $('form.image_file select#image_file_district_id option[data-parent-id="' + val + '"]').css('display:inherit;');
      $('form.image_file div#image_file_district_id_input').show();  
    }else{
      $('form.image_file div#image_file_district_id_input').hide();  
      $('form.image_file select#image_file_district_id').val('');
    }
  }

  $('form.image_file select#image_file_city_id').change(function(){
    show_image_file_districts_for_city($(this).val());
  });

  if ($('form.image_file select#image_file_city_id').length > 0){
    show_image_file_districts_for_city($('form.image_file select#image_file_city_id').val());
  }

  ///////// pairing upload form
  // only show the options that are for the selected city
  // if none, hide districts
  function show_pairing_districts_for_city(val){
    if (val != '' && $('form.pairing-upload select#image_file1_district_id option[data-parent-id="' + val + '"]').length > 0){
      $('form.pairing-upload select#image_file1_district_id option').css('display:none;');
      $('form.pairing-upload select#image_file1_district_id option[data-parent-id="' + val + '"]').css('display:inherit;');
      $('form.pairing-upload div#image_file1_district_id_input').show();  
    }else{
      $('form.pairing-upload div#image_file1_district_id_input').hide();  
      $('form.pairing-upload select#image_file1_district_id').val('');
    }
  }

  $('form.pairing-upload select#image_file1_city_id').change(function(){
    show_pairing_districts_for_city($(this).val());
  });

  if ($('form.pairing-upload select#image_file1_city_id').length > 0){
    show_pairing_districts_for_city($('form.pairing-upload select#image_file1_city_id').val());
  }

});
