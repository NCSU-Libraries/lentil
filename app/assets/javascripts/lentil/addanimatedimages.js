//= require animatedimages/js/modernizr.custom.26633.js
//= require animatedimages/js/jquery.gridrotator.js
function addanimatedimages() {

    $(function() {
        $( '#ri-grid' ).gridrotator( {
            rows : 3,
            columns : 8,
            maxStep : 2,
            interval : 4500,
            animType : 'rotateRight',
            animSpeed: 1000,
            w2000 : {
            rows : 3,
            columns: 6
            },
            w1750 : {
            rows : 4,
            columns : 6
            },
            w1024 : {
            rows : 6,
            columns : 3
            },
            w768 : {
            rows : 5,
            columns : 3
            },
            w480 : {
            rows : 8,
            columns : 4
            },
            w320 : {
            rows : 4,
            columns : 3
            },
            w240 : {
            rows : 4,
            columns : 3
            }
        });

    });
}