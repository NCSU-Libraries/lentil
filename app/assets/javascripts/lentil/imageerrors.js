function addimageerrors() {
    $("a[target=_blank]").attr("rel", "noopener noreferrer");

    $(".instagram-img, .battle-img, .fancybox-img, .fancybox-video").off("error").on("error", function () {
        $(this).parents("div.image-tile, li.image-animate-tile").remove();
    });
}
