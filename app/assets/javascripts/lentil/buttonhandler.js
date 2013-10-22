function buttonhandler() {

    $(".like-btn, .flag-confirm").click(function(e) {
        button = $(this);
        imageId = $(".fancybox-wrap, .image-show").attr("id");
        if (!$(button).is(".already-clicked")) {
            url = $(button).attr("href");
            $.post(url, function() {
                $(button).addClass("already-clicked");
                $("#" + imageId + " .text-overlay").find(".initial-state").addClass("already-clicked");
            });
        }

        if ($(button).is(".like-btn")) {
            $("#" + imageId + " .like-btn").toggle();
        } else if ($(button).is(".flag-confirm")) {
            $("#" + imageId + " .flag-btn.initial-state").remove();
            $("#" + imageId + " .flag-btn.secondary-state").show();
            $('.modal').modal('hide');
        }
        e.preventDefault();
    });
}