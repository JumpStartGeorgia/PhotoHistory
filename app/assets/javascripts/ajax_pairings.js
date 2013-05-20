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

    var content_url = $(this).attr('href').replace(/\.json(\?.*)?$/, '$1').replace(/(\?.*)?$/, '.json$1');
    console.log('click function, calling get_content on ' + content_url);
    get_content(content_url, true);


    return false;
  });



  function create_pushstate (url, data_url, id, title)
  {
    // create new page title
    var separator = '|';
    var new_title = $.trim(title) + ' ' + document.title.slice(document.title.lastIndexOf(separator));
    console.log('pushstate created for ' + url + '; data_url: ' + data_url);

    window._load_state = false;
    History.pushState({id: id, url: data_url}, new_title, url);
  }




  // Prepare
  var History = window.History; // Note: We are using a capital H instead of a lower h
  if (!History.enabled)
  {
    // History.js is disabled for this browser.
    // This is because we can optionally choose to support HTML4 browsers or not.
    return false;
  }

//window._load_state = false;
  History.replaceState({id: gon.pairing_id, url: gon.pairing_url}, $(document).attr('title'), $(location).attr('href'));


  // Bind to StateChange Event
  History.Adapter.bind(window, 'statechange', function ()
  {
  /*
    if ('ignore_statechange' in window && window.ignore_statechange)
    {
      console.log('statechange; ignoring this one');
      window.ignore_statechange = false;
      console.log('ignore_statechange set to ', ignore_statechange);
      return;
    }
  */

    var state = History.getState(); // Note: We are using History.getState() instead of event.state
    console.log('statechange; state: ', state);
    console.log('checking _load_state ', window._load_state == undefined, '||', window._load_state);
    if (window._load_state == undefined || window._load_state)
    {
      console.log('_load_state is true; calling load_state()');
      load_state(state.data.url, state.data.id);
    }
    else
    {
      console.log('_load_state is false; setting it to true');
      window._load_state = true;
    //window.ignore_statechange = true;
    //History.replaceState(state.data, state.title, state.url);
    }
  });



  function get_content (url, _create_pushstate)
  {
    content_status.loading();
    console.log('get_content() called for url ' + url + '; _create_pushstate is', _create_pushstate);
    $.get(url, function (resp)
    {
      console.log('get_content() got response from ' + url + '; resp: ', resp);
      var imgs = [];
      var loaded_count = 0;
      for (var i in resp.image_urls)
      {
        var src = resp.image_urls[i];
        imgs[i] = new Image;
        imgs[i].onload = function ()
        {
          loaded_count ++;
          if (loaded_count == resp.image_urls.length)
          {
            $(' img.layer1').attr('src', resp.image_urls[0]);
            $('.layer2 img').attr('src', resp.image_urls[1]);

            replace_description(resp.description);
            replace_social(resp.social);

            window.draggable_ratio = .5;
            recreate_draggable();

            console.log('_create_pushstate is ', _create_pushstate);
            if (_create_pushstate)
            {
              console.log('calling create_pushstate for url ' + resp.url);
              create_pushstate(resp.url, url, resp.pairing.id, resp.pairing.title);
            }

            content_status.loaded();
          }
        }
        imgs[i].src = src;
      }
      update_link_parameters(resp.url, resp.pairing.id);
    });
  }


  function load_state (url, id)
  {
    $('html,body').animate({scrollTop: 0}, 500);
    console.log('load_state() called for url ' + url + '; calling get_content()');
    get_content(url, false);
  }


  function update_link_parameters (url, id)
  {
    console.log('updating links for url: ' + url + ' and id: ' + id);
    $('.controls.left  a').attr('href', $('.controls.left  a').attr('href').replace(/(next|previous)\/[0-9]+/, '$1/' + id));
    $('.controls.right a').attr('href', $('.controls.right a').attr('href').replace(/(next|previous)\/[0-9]+/, '$1/' + id));
  }


  function replace_description (val)
  {
    $('#image_text').html(val);
  }


  function replace_social (val)
  {
    $('#photo_title_social .likes').html(val);
    /**
     * reinitialise "Share This" script on ajax page refresh. 
     **/
    delete stLight;
    delete stButtons;
    delete stFastShareObj;
    delete stIsLoggedIn;
    delete stWidget;
    delete stRecentServices;
    $.getScript('http://w.sharethis.com/button/buttons.js', function ()
    {
      var switchTo5x = true;
      stLight.options(st_options);
    });
  }



})(window);




