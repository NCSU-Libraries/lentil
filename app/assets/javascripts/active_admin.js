//= require active_admin/base
//= require select2
//= require expanding/expanding

$(document).ready(function() {
    var url;

    // Fix subdirectory deployment nav links
    // https://github.com/activeadmin/activeadmin/issues/101#issuecomment-244028956
    $('#header li a').each(function() {
      var current_location, href, location_prefix, url_suffix;
      href = $(this).attr('href');
      url_suffix = href.replace(/.*\/admin\//, '');
      current_location = document.location.pathname;
      location_prefix = current_location.replace(/admin\/?.*/, "admin/");
      return $(this).attr('href', location_prefix + url_suffix);
    });

    if (window.location.pathname.indexOf('/lentil_tagsets/new') > -1) {
      url = '../lentil_tags/tags_api';
    } else {
      url = '../../lentil_tags/tags_api';
    }

    $(".lentil-admin-select").select2({
      width: 200,
    	ajax: {
        url: url,
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term
          };
        },
        processResults: function (data, page) {
          // parse the results into the format expected by Select2.
          // since we are using custom formatting functions we do not need to
          // alter the remote JSON data
          return {
            results: $.map(data, function (item) {
              return {
                text: item.name,
                id: item.id
              };
            })
          };
        },
        cache: true
      }
    });
});