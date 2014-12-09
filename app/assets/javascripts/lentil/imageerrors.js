function addimageerrors() {
    $("body").on(
        "error",
        ".instagram-img, .battle-img, .fancybox-img",
        function () {
            $(this).parents("div.image-tile, li.image-animate-tile").remove();
            if ($("body.images_animate") || $("body.images_staff_picks_animate")) {
                addanimatedimages();
            }
        }
    );
}
