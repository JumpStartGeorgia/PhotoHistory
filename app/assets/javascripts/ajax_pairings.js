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
      var sc = [];
      for (var i = 0, num = Array.prototype.slice.call(arguments).length; i < num; i ++)
      {
        sc.push('arguments[' + i + ']');
      }
      eval('console.log(' + sc.join(', ') + ')');
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


  $('.controls a').click(function (e)
  {
    e.preventDefault();
    e.stopPropagation();

    var parent = $(this).parent();
    if (parent.hasClass('left'))
    {
      var direction = 'left';
    }
    else if (parent.hasClass('right'))
    {
      var direction = 'right';
    }
    else
    {
      return true;
    }

    var content_url = $(this).attr('href')/*.replace(/\.json(\?.*)?$/, '$1')*/.replace(/(\?.*)?$/, '.json$1');
    debug.log('click function, calling get_content on ' + content_url);
    debug.log('direction is ' + direction);
    get_content(content_url, true, direction);

    return false;
  });



  function create_pushstate (url, data_url, id, title, direction)
  {
    // create new page title
    var separator = '|';
    var new_title = $.trim(title) + ' ' + document.title.slice(document.title.lastIndexOf(separator));
    debug.log('pushstate created for ' + url + '; data_url: ' + data_url);

    window._load_state = false;
    History.pushState({id: id, url: data_url, direction: 'left'}, new_title, url);
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
  History.replaceState({id: gon.pairing_id, url: gon.pairing_url, direction: 'left'}, $(document).attr('title'), $(location).attr('href'));


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



  function get_content (url, _create_pushstate, direction)
  {
  //content_status.loading();
    debug.log('get_content() called for url ' + url + '; _create_pushstate is', _create_pushstate);
    var direction = direction || false;
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
          /*
            $(' img.layer1').attr('src', resp.image_urls[0]);
            $('.layer2 img').attr('src', resp.image_urls[1]);

            window.draggable_ratio = .5;
            recreate_draggable();
          */
            var clone = $('.layer2').closest('.item-container').clone();
            clone
            .find(' img.layer1').attr('src', resp.image_urls[0]).end()
            .find('.layer2 img').attr('src', resp.image_urls[1]).css('width', resp.dimensions.width).end();
          /*
            if (direction == 'left')
            {
              var opposite = 'right';
              clone.prependTo($('.photo'));
            }
            else
            {
              var opposite = 'left';
              clone.appendTo($('.photo'));
            }

            $('#photo_container').animate({height: resp.dimensions.height}, function ()
            {

              var animateprop = {};
              animateprop[opposite] = '0%';

              clone
              .addClass('moving')
              .animate(animateprop, {duration: 1000, queue: false, complete: function (){ $(this).removeClass('moving').css(opposite, ''); }});

              animateprop[opposite] = '-100%';

              $('.item-container:not(.moving)').animate(animateprop, {duration: 1000, queue: false, complete: function (){ $(this).remove(); }});

            });
          */

            $('.photo').css({width: resp.dimensions.width, height: resp.dimensions.height});
            clone.appendTo($('.photo'));
            $('.item-container').css('position', 'absolute');
            $('.item-container').eq(0).animate({opacity: 0}, {complete: function (){ $(this).remove(); draggable_ratio = .5; recreate_draggable(); }, queue: false}).end().eq(1).css('opacity', 0).animate({opacity: 1}, {queue: false});

            replace_description(resp.description);
            replace_social(resp.url, resp.pairing.title, resp.social);
            replace_headers(resp.pairing.title, resp.years, resp.pairing_index);
            update_map(resp.latlon, resp.marker_text);
            update_link_parameters(resp.url, resp.pairing.id);

            debug.log('_create_pushstate is ', _create_pushstate);
            if (_create_pushstate)
            {
              debug.log('calling create_pushstate for url ' + resp.url);
              create_pushstate(resp.url, url, resp.pairing.id, resp.pairing.title, direction);
            }

          //content_status.loaded();
          }
        }
        imgs[i].src = src;
      }
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
    FB.XFBML.parse();
    debug.log('parsing facebook comments');
  }

  function replace_headers (title, years, index)
  {
    $('#photo_title_social .title').html(title);
    $('#image_left_year  span:first').html(years[0]);
    $('#image_right_year span:first').html(years[1]);
    $('#image_count').html(index);
  }

  function replace_social (url, title, data)
  {
    var spans = new Array(5).join('<span></span>');
    $('#photo_title_social .likes').html(spans).children().attr('id', function (i){ return 'st_button_' + i; });

    stWidget.addEntry({
        "service": "fblike",
        "element": document.getElementById('st_button_0'),
        "url": url,
        "title": title,
        "type": "fblike",
        "image": data.fb_img,
        "summary": data.summary
    });

    stWidget.addEntry({
        "service": "twitter",
        "element": document.getElementById('st_button_1'),
        "url": url,
        "title": title,
        "type": "hcount",
        "image": data.fb_img,
        "summary": data.summary
    });

    stWidget.addEntry({
        "service": "pinterest",
        "element": document.getElementById('st_button_2'),
        "url": url,
        "title": title,
        "type": "hcount",
        "image": data.pin_img,
        "summary": data.summary
    });

    stWidget.addEntry({
        "service": "sharethis",
        "element": document.getElementById('st_button_3'),
        "url": url,
        "title": title,
        "type": "hcount",
        "image": data.pin_img,
        "summary": data.summary
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




