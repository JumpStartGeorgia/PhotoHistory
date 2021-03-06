$(function()
{

  window.draggable_ratio = .5;

  function recreate_draggable ()
  {
    if (gon.load_image_pairing){
      var el = $('.draggable');
      var el_width = el.width();

      var overlay = $('.overlay');
      var ow = overlay.width();
    //var offset = overlay.offset();
      var w = overlay.offset().left - el_width / 2;

      el.draggable('destroy').draggable({
        containment: [w, 0, w + ow, 0],
        axis: 'x',
        cursor: 'col-resize',
        create: function (e, ui)
        {
          var pwr = ow * draggable_ratio;
          $(this).css('left', pwr - el_width / 2).show().parent().siblings('.layer2').width(ow - pwr).children('img').width($(this).parent().siblings('img.layer1').width());
        },
        drag: function (e, ui)
        {
          $(this).parent().siblings('.layer2').width(ow - ui.position.left - el_width / 2);
          window.draggable_ratio = (ui.position.left + el_width / 2) / ow;
        }
      });
    }
  }

  if (gon.load_image_pairing){
    $('a#read-more').click(function(e){
      $(this).parent().find('+ #long-desc').fadeIn();
      $(this).parent().hide();
      e.preventDefault();
    });

    $(window).bind('load resize', recreate_draggable);

    $(window).keydown(function (event)
    {
      switch (event.keyCode)
      {
        case 37:
        //console.log('left');
          if ($('.controls.left a').length)
          {
            $('.controls.left a').get(0).click();
          }
          break;
        case 38:
        //console.log('up');
          break;
        case 39:
        //console.log('right');
          if ($('.controls.right a').length)
          {
            $('.controls.right a').get(0).click();
          }
          break;
        case 40:
        //console.log('down');
          break;
      }
    });
  }
});
