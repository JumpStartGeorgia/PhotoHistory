$(function ()
{

  if (!$('[id*=galleriffic]').length)
  {
    return;
  }

  window.gf = {
    stepsCount: 0
  };

  gf.options1 = {
    delay:                       9e+9, // in milliseconds
    numThumbs:                   9, // The number of thumbnails to show page
    preloadAhead:                40, // Set to -1 to preload all images
    enableTopPager:              false,
    enableBottomPager:           true,
    maxPagesToShow:               7,  // The maximum number of pages to display in either the top or bottom pager
    imageContainerSel:           '#galleriffic1-image', // The CSS selector for the element within which the main slideshow image should be rendered
    controlsContainerSel:         '', // The CSS selector for the element within which the slideshow controls should be rendered
    captionContainerSel:          '', // The CSS selector for the element within which the captions should be rendered
    loadingContainerSel:          '', // The CSS selector for the element within which should be shown when an image is loading
    renderSSControls:             false, // Specifies whether the slideshow's Play and Pause links should be rendered
    renderNavControls:            false, // Specifies whether the slideshow's Next and Previous links should be rendered
    clickingCurrentChangesSlide:  false, // I added this; if true, when you click the current image, it goes to next one
    playLinkText:                 'Play',
    pauseLinkText:                'Pause',
    prevLinkText:                 'Previous',
    nextLinkText:                 'Next',
    nextPageLinkText:             'Next &rsaquo;',
    prevPageLinkText:             '&lsaquo; Prev',
    enableHistory:                false, // Specifies whether the url's hash and the browser's history cache should update when the current slideshow image changes
    enableKeyboardNavigation:     false, // Specifies whether keyboard navigation is enabled
    autoStart:                    false, // Specifies whether the slideshow should be playing or paused when the page first loads
    syncTransitions:              false, // Specifies whether the out and in transitions occur simultaneously or distinctly
    defaultTransitionDuration:    400, // If using the default transitions, specifies the duration of the transitions
    onSlideChange:                slideChange1, // accepts a delegate like such: function(prevIndex, nextIndex) { ... }
    onTransitionOut:              undefined, // accepts a delegate like such: function(slide, caption, isSync, callback) { ... }
    onTransitionIn:               undefined, // accepts a delegate like such: function(slide, caption, isSync) { ... }
    onPageTransitionOut:          undefined, // accepts a delegate like such: function(callback) { ... }
    onPageTransitionIn:           undefined, // accepts a delegate like such: function() { ... }
    onImageAdded:                 undefined, // accepts a delegate like such: function(imageData, $li) { ... }
    onImageRemoved:               undefined  // accepts a delegate like such: function(imageData, $li) { ... }
  };

  gf.options2 = Object.create(gf.options1);
  gf.options2.imageContainerSel = '#galleriffic2-image';
  gf.options2.onSlideChange = slideChange2;

  function slideChange1 (prev, index)
  {
    var el = this.find('ul.thumbs > li').eq(index);
    var input = this.find('input[type="hidden"]');
    var id = el.data('value');
    var year = el.data('year');
    input.val(id);

    gf.stepsCount ++;
    if (gf.stepsCount > 1)
    {
      if (gf.ajax != undefined)
      {
        gf.ajax.abort();
      }
      gf.ajax = $.get(el.data('href'), function (resp)
      {
        $('#galleriffic2-thumbs').replaceWith(resp);
        $('#galleriffic2-thumbs').galleriffic(gf.options2);
      });
    }
    if (gf.stepsCount == 2)
    {
      $('#galleriffic2, #galleriffic2-image').fadeIn('fast');
    }
  }

  function slideChange2 (prev, index)
  {
    var el = this.find('ul.thumbs > li').eq(index);
    var input = this.find('input[type="hidden"]');
    input.val(el.data('value'));
  }

  var gallery1 = $('#galleriffic1-thumbs').galleriffic(gf.options1);
  if ($('#galleriffic2-thumbs .thumbs > li').length)
  {
    $('#galleriffic2, #galleriffic2-image').show();
    var gallery2 = $('#galleriffic2-thumbs').galleriffic(gf.options2);
  }

});
