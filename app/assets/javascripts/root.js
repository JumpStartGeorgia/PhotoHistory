$(function()
{

  window.draggable_ratio = .5;

  window.recreate_draggable = function (reset_ratio, create_callback)
  {
    if (typeof reset_ratio == 'boolean' && reset_ratio)
    {
      draggable_ratio = .5;
    }

    if (gon.load_image_pairing)
    {
      var el = $('.draggable');
      el.hide();
      var el_width = el.width();

      var overlay = $('.item .overlay');
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
        //$(this).css('left', pwr - el_width / 2).show().parent().siblings('.layer2').width(ow - pwr).children('img').width($(this).parent().siblings('img.layer1').width());
        /*
          if (typeof create_callback == 'function')
          {
            create_callback();
          }
        */
          animop = {queue: false, duration: 300};
          $(this).animate({left: pwr - el_width / 2}, animop).show().parent().siblings('.layer2').animate({width: ow - pwr}, animop).children('img').animate({width: $(this).parent().siblings('img.layer1').width()}, animop);
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
    $(window).bind('load resize', recreate_draggable);


    $(window).keydown(function (event)
    {
      switch (event.keyCode)
      {
        case 37:
        //console.log('left');
          if ($('.controls.left a').length)
          {
          //$('.controls.left a').get(0).click();
            $('.controls.left a').click();
          }
          break;
        case 38:
        //console.log('up');
          break;
        case 39:
        //console.log('right');
          if ($('.controls.right a').length)
          {
          //$('.controls.right a').get(0).click();
            $('.controls.right a').click();
          }
          break;
        case 40:
        //console.log('down');
          break;
      }
    });
  }
});
