function addimageerrors() {
    $("img.instagram-img, img.battle-img, img.fancybox-img").on("error", function () {
        $(this).parents("div.image-tile, li.image-animate-tile").remove();
        /*if ($("body.images_animate") || $("body.images_staff_picks_animate")) {
            addanimatedimages();
        }*/
    });
}