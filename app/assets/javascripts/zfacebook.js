$(document).ready(function(){
	// facebook comments
	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=" + gon.fb_app_id;
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));

	// set the width of the facebook comments box
	if (gon.show_fb_comments){
		$('div.fb-comments').attr('data-width',$('#image_comments').width());
	}
});
