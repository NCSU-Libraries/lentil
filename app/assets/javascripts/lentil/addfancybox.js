var FancyBoxCloseFunctionState = {

    // object literal for tracking important
    // state information so we know
    // how to change the url in response
    // to user actions such as
    // dismissing fancybox from clicking or using back button
    popcalled: false,
    fancyboxvisible: false,
    pathname: window.location.pathname.replace(/\/?$/, '/')
};

// listen for popstate (back/forward, etc.)
function listenforpopstate() {
    window.onpopstate = function(){
        if ($('body').is(".lentil-images_show")) {
            // if we're on the images page
            // and this doesn't look like an image url
            // switch to page that matches the url
            if (!/images\/[0-9]/.test(window.location.pathname)) {
              window.location.href = window.location.pathname;
            }
        } else {

            // if we're on any other page (not an image)
            // but the url looks like an image url
            // switch to the image page that matches the url
            if (/images\/[0-9]/.test(window.location.pathname)) {
              window.location.href = window.location.pathname;
            }
        }
    };
}

function pushimageurl() {

    // extract application root url
    var approot = FancyBoxCloseFunctionState.pathname.replace(/(photographers\/\d+|images|thisorthat\/battle|thisorthat\/battle_leaders)\/\D*\/?/, "");

    // construct an image show url with the right image id
    replacementUrl =  approot + "images/" + imageId.replace("image_","");

    // get rid of any double slashes (TO DO: remove this?)
    if (/\/\//.test(replacementUrl)) {
        replacementUrl = replacementUrl.replace("//","/");
    }

    // push the url for the displayed image to the browser
    window.history.pushState(null, null, replacementUrl);

    Lentil.ga_track(['_trackPageview', replacementUrl]);

    // listen for popstate (back/forward button)
    window.onpopstate = function(){
        if (/images\/[0-9]/.test(window.location.pathname)) {
            // if this url looks like an image show url then switch
            // the browser to the displayed url
            window.location.href = window.location.pathname;
        } else {
            // otherwise switch the popcalled state to true
            // and close the fancybox
            FancyBoxCloseFunctionState.popcalled = true;
            $.fancybox.close();
            // switch the popcalled flag to false
            // and the fancybox visible flag to false
            FancyBoxCloseFunctionState.popcalled = false;
            FancyBoxCloseFunctionState.fancyboxvisible = false;
        }
    };
}

function addfancybox() {

    $(".fancybox").fancybox({
        openEffect  : 'none',
        closeEffect : 'none',
        nextEffect  : 'none',
        prevEffect  : 'none',
        live : true,
        loop : false,
        minWidth : '250px',
        type: 'html',
        helpers     : {
            title   : { type : 'inside' },
            overlay : { locked : false }
        },
        afterLoad: function(current, previous) {

          // pushing base url so that back/close returns to image gallery
          // instead of image show
          window.history.pushState(null,null,FancyBoxCloseFunctionState.pathname);
        },
        beforeShow  : function() {
			var img = $(this.element).children(".instagram-img");
			if($(img).attr("data-media-type") === "video") {
				var video_url = $(img).attr("src");
				//this.content = "<video src='" + video_url + "' height='320' width='320' controls='controls'></video>";
				$(".fancybox-inner").html('<video controls="controls" height="100%"  width="90%" src="' + video_url + '"></video>');
				var vid = $(".fancybox-inner").children("video")[0];
				vid.oncanplay = function() {
					$.fancybox.reposition();
				}
			}
			else {
				var image_url = $(img).attr("src");
				$(".fancybox-inner").html('<img class="fancybox-image" src="' + image_url + '" />');
			}

            this.title = $(this.element).next(".text-overlay").html();
            imageId = $(this.element).parents("div").attr("id");
            $(".fancybox-wrap").attr('id', imageId);
            pushimageurl(imageId);
        },
        afterShow : function() {

            // checks whether browser understands touch events
            // if so the next/prev buttons are disabled
            // and swipe down/right is added to advance slides
            if ('ontouchstart' in document.documentElement){
                $('.fancybox-nav').css('display','none');
                $('.fancybox-wrap').swipe({
                    swipe : function(event, direction) {
                        if (direction === 'right' || direction === 'down') {
                            $.fancybox.prev( direction );
                        } else {
                            $.fancybox.next( direction );
                        }
                    }
                });
            }

            // adds button handling script to displayed fancybox buttons
            buttonhandler();

            // this is to check that the fancybox is really visible
            // afterClose is fired off on fancybox open -- a bug
            FancyBoxCloseFunctionState.fancyboxvisible = true;
            imageId = $(this.element).parents("div").attr("id");

            // check whether we're on the last image in the gallery
            // and whether there's more than one page of images
            // if so, launch the spinner, fetch the next set of images
            // and scroll to the current image
            // (callback on addininfintescroll() does the work of reloading fancybox)
            if (this.index == this.group.length - 1 && $("div#paging a").length > 0) {
                $('#spinner-overlay').show();
                $('#spinner-overlay').css("z-index", 10000000);
                target = document.getElementById('spinner-overlay');
                FANCYBOX_SPINNER = new Spinner(opts).spin(target);
                //$("body").animate({scrollTop: $("div#" + imageId).offset().top }, 1500);
                $('div.images').infinitescroll('retrieve');
            }
        },
        afterClose : function() {
            if (FancyBoxCloseFunctionState.popcalled === false && FancyBoxCloseFunctionState.fancyboxvisible === true) {

              // if after closing the fancybox there is no pop event
              // and the fancybox is visible
              // (this afterClose event also fires when fancybox opens
              // -- a bug we're getting around with this hack)
              // switch the flags and point the url at the previous page
              // should be an image tile view (recent, popular, staff picks, etc.)
              FancyBoxCloseFunctionState.fancyboxvisible = false;
              window.history.back();
            }
        }
    });
}
