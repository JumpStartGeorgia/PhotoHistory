$(function()
{

  var overlay = $('.overlay');
//var offset = overlay.offset();
  var w = overlay.offset().left - $('.draggable').width() / 2;

  $('.draggable').draggable({
    containment: [w, 0, w + overlay.width(), 0],
    axis: 'x',
    cursor: 'col-resize',
    create: function (e, ui)
    {
      //create a div on create event in overlay, give overlay overflow hidden
      $(this).css('left', $(this).parent().width() / 2 - $(this).width() / 2).show().parent().siblings('.layer2').children('img').width($(this).parent().siblings('img.layer1').width());
    },
    drag: function (e, ui)
    {
      $(this).parent().siblings('.layer2').width($(this).parent().width() - ui.position.left - $(this).width() / 2);
    }
  });




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
