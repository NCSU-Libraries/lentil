// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require lentil/buttonhandler
//= require fancybox
//= require lentil/addfancybox
//= require infinitescroll/jquery.infinitescroll
//= require bootstrap
//= require lentil/addinfinitescroll
//= require lentil/imageerrors
//= require lentil/addanimatedimages
//= require touchswipe/jquery.touchSwipe
//= require lentil/addobjectfit

// wrapped in anonymous function so FANCYBOX_SPINNER
// is accessible by both addinfinitescroll and addfancybox
(function() {

    var FANCYBOX_SPINNER;

    // fancybox spinner options
    opts = {
        lines: 13, // The number of lines to draw
        length: 7, // The length of each line
        width: 4, // The line thickness
        radius: 10, // The radius of the inner circle
        corners: 1, // Corner roundness (0..1)
        rotate: 0, // The rotation offset
        color: '#fff', // #rgb or #rrggbb
        speed: 1, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: 'auto', // Top position relative to parent in px
        left: 'auto' // Left position relative to parent in px
    };

    $(document).ready(function() {

        $('body').on('touchstart.dropdown', '.dropdown-menu', function (e) { e.stopPropagation(); });

        addimageerrors();
        addobjectfit();

        if (window.history.pushState) {
            addfancybox();
            listenforpopstate();
            addinfinitescroll();
        }

        if ($("body.image-show")) {
            buttonhandler();
        }

    });
  })();
