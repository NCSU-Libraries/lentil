function addimageerrors() {
    $(".instagram-img, .battle-img, .fancybox-img").off("error").on("error", function () {
        $(this).parents("div.image-tile, li.image-animate-tile").remove();
        /*if ($("body.images_animate") || $("body.images_staff_picks_animate")) {
            addanimatedimages();
        }*/
    });
}
