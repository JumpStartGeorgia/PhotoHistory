$(function()
{

  window.draggable_ratio = .5;

  function recreate_draggable ()
  {
    var el = $('.draggable');
    var el_width = el.width();

    var overlay = $('.overlay');
  //var offset = overlay.offset();
    var w = overlay.offset().left - el_width / 2;

    el.draggable('destroy').draggable({
      containment: [w, 0, w + overlay.width(), 0],
      axis: 'x',
      cursor: 'col-resize',
      create: function (e, ui)
      {
        $(this).css('left', $(this).parent().width() * draggable_ratio - el_width / 2).show().parent().siblings('.layer2').children('img').width($(this).parent().siblings('img.layer1').width());
      },
      drag: function (e, ui)
      {
        var pw = $(this).parent().width();
        $(this).parent().siblings('.layer2').width(pw - ui.position.left - el_width / 2);
        window.draggable_ratio = (ui.position.left + el_width / 2) / pw;
      }
    });
  }


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

});
