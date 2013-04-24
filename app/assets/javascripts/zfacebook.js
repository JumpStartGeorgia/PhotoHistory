$(document).ready(function(){
 window.fbAsyncInit = function() {
    // init the FB JS SDK
    FB.init({
      appId      : gon.fb_app_id,                        // App ID from the app dashboard
//      channelUrl : '//WWW.YOUR_DOMAIN.COM/channel.html', // Channel file for x-domain comms
      status     : true,                                 // Check Facebook Login status
      xfbml      : true
    });

    // Additional initialization code such as adding Event Listeners goes here

    var PAGE_ID  = '404372876323164';
/*
     FB.Event.subscribe('auth.sessionChange', function(response) {
console.log(response);
            if(response.session){
console.log('has session');
                //check to see if user is a fan of the page
                var query = FB.Data.query( 'select page_id from page_fan where uid='+response.session.uid+' and page_id ='+PAGE_ID);
                query.wait( function(rows) {
console.log('query response');
console.log(rows);
                    if(rows.length){
                        //user already likes your page
                    }else{
                        //user has not yet liked your page
                    }
                });
            }else{
                //user has not yet logged in
            }
        });
*/
/*
FB.getLoginStatus(function(response) {
console.log(response);
  if (response.status === 'connected') {
console.log('connected');
    // the user is logged in and has authenticated your
    // app, and response.authResponse supplies
    // the user's ID, a valid access token, a signed
    // request, and the time the access token 
    // and signed request each expire
    var uid = response.authResponse.userID;
    var accessToken = response.authResponse.accessToken;
  } else if (response.status === 'not_authorized') {
console.log('not auth');
    // the user is logged in to Facebook, 
    // but has not authenticated your app
  } else {
console.log('not logged in');
    // the user isn't logged in to Facebook.
  }
 });
*/


  };


  // Load the SDK asynchronously
  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/all.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
/*
	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=" + gon.fb_app_id;
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
*/

  // show facebook like us popup
//  if (document.cookie.indexOf('visited=true') == -1) {
//    var not_show_for = 1000*60*60*24*30;
//    var expires = new Date((new Date()).valueOf() + not_show_for);
//    document.cookie = "visited=true;expires=" + expires.toUTCString();


//    $FB_PAGE_ID = '404372876323164'; //assign facebook page id.  

/*
    $.fancybox(
//      '<div id="fb-popup-like-box"><h1>get updates and follow us</h1><div class="fb-like-box" data-href="http://www.facebook.com/feradi.info" data-width="292" data-show-faces="true" data-stream="false" data-header="false"></div></div>',
      $('#fb-popup-like-box').html(),
      {
    	  'width': 500,
        'transitionIn': 'elastic',
        'transitionOut': 'elastic'
      }
    );
//  }
*/


});
