(function(window,undefined){

  $.ajaxSetup({
    cache: true
  });

  var debug = {
    enabled: false,
    log: function ()
    {
      if (!this.enabled)
      {
        return;
      }
      var sc = '';
      for (var i = 0, num = arguments.length; i < num; i ++ )
      {
        sc += 'arguments[' + i + '], ';
      }
      sc = sc.replace(/,\s$/, '');
      eval('console.log(' + sc + ')');
    }
  };

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
    debug.log('click function, calling get_content on ' + content_url);
    get_content(content_url, true);


    return false;
  });



  function create_pushstate (url, data_url, id, title)
  {
    // create new page title
    var separator = '|';
    var new_title = $.trim(title) + ' ' + document.title.slice(document.title.lastIndexOf(separator));
    debug.log('pushstate created for ' + url + '; data_url: ' + data_url);

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
      debug.log('statechange; ignoring this one');
      window.ignore_statechange = false;
      debug.log('ignore_statechange set to ', ignore_statechange);
      return;
    }
  */

    var state = History.getState(); // Note: We are using History.getState() instead of event.state
    debug.log('statechange; state: ', state);
    debug.log('checking _load_state ', window._load_state == undefined, '||', window._load_state);
    if (window._load_state == undefined || window._load_state)
    {
      debug.log('_load_state is true; calling load_state()');
      load_state(state.data.url, state.data.id);
    }
    else
    {
      debug.log('_load_state is false; setting it to true');
      window._load_state = true;
    //window.ignore_statechange = true;
    //History.replaceState(state.data, state.title, state.url);
    }
  });



  function get_content (url, _create_pushstate)
  {
    content_status.loading();
    debug.log('get_content() called for url ' + url + '; _create_pushstate is', _create_pushstate);
    $.get(url, function (resp)
    {
      debug.log('get_content() got response from ' + url + '; resp: ', resp);
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
            replace_headers(resp.pairing.title, resp.years, resp.pairing_index);
            update_map(resp.latlon, resp.marker_text);

            debug.log('_create_pushstate is ', _create_pushstate);
            if (_create_pushstate)
            {
              debug.log('calling create_pushstate for url ' + resp.url);
              create_pushstate(resp.url, url, resp.pairing.id, resp.pairing.title);
            }

            window.draggable_ratio = .5;
            recreate_draggable();

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
  //$('html,body').animate({scrollTop: 0}, 500);
    debug.log('load_state() called for url ' + url + '; calling get_content()');
    get_content(url, false);
  }


  function update_link_parameters (url, id)
  {
    debug.log('updating links for url: ' + url + ' and id: ' + id);
    $('.controls a').attr('href', function (index, attr)
    {
      return attr.replace(/(next|previous)\/[0-9]+/, '$1/' + id);
    });

    $('.locale a').attr('href', function (index, attr)
    {
      var s = (attr.indexOf('?') > -1) ? '&' : '?';
      return attr.replace(/(\?|&)pairing=[0-9]+/, '') + s + 'pairing=' + id;
    });
  }


  function replace_description (val)
  {
    $('#image_text').html(val);
  }

  function replace_headers (title, years, index)
  {
    $('#photo_title_social .title').html(title);
    $('#image_left_year  span:first').html(years[0]);
    $('#image_right_year span:first').html(years[1]);
    $('#image_count').html(index);
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

  function update_map (latlon, popup_content)
  {
    var point = new L.LatLng(latlon[0], latlon[1]);
    (function (map, m)
    {
      m.setLatLng(point);
      m._popup.setContent(popup_content);
      map.setView(point, gon.zoom);
    })(window.pairing_map, window.pairing_marker);
  }



})(window);




