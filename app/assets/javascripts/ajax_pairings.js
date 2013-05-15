(function(window,undefined){

  var content_status = {
    loading: function ()
    {
      $('#photo_container').css('opacity', 0.5);
    },
    loaded: function ()
    {
    $('#photo_container').css('opacity', 1);
    }
  };


  $('.controls a').click(function ()
  {
    var parent = $(this).parent();
    if (parent.hasClass('left'))
    {
      var type = 'left';
    }
    else if (parent.hasClass('right'))
    {
      var type = 'right';
    }
    else
    {
      return true;
    }

    content_status.loading();
    $.get($(this).attr('href').replace(/\.json$/, '') + '.json', function (resp)
    {
      var imgs = [];
      var loaded_count = 0;
      for (var i in resp.image_urls)
      {
        var url = resp.image_urls[i];
        imgs[i] = new Image;
        imgs[i].onload = function ()
        {
          loaded_count ++;
          if (loaded_count == resp.image_urls.length)
          {
            $('img.layer1 ').attr('src', resp.image_urls[0]);
            $('.layer2 img').attr('src', resp.image_urls[1]);
            recreate_draggable();
            content_status.loaded();
          }
        }
        imgs[i].src = url;
      }
    });

    return false;
  });








  // Prepare
  var History = window.History; // Note: We are using a capital H instead of a lower h
  if (!History.enabled)
  {
     // History.js is disabled for this browser.
     // This is because we can optionally choose to support HTML4 browsers or not.
    return false;
  }

  // Bind to StateChange Event
  History.Adapter.bind(window, 'statechange', function ()
  {
    var State = History.getState();
    History.log(State.data, State.title, State.url);
  });

})(window);
