$(function()
{

  function recreate_draggable(){
    // kill draggable if exists
    $('.draggable').draggable( "destroy" );

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

  }

  
  $(window).bind('load resize', recreate_draggable);
  
});
