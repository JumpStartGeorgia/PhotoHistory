$(function()
{
  $('.draggable').draggable({ 
    containment: 'parent',
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


});
