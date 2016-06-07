//= require active_admin/base
//= require select2
//= require expanding/expanding
//= require js-routes

$(document).ready(function() {
    $(".lentil-admin-select").select2({
    	ajax: {
        url: Routes.tags_api_admin_lentil_tags_path,
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term
          }
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
              }
            })
          };
        },
        cache: true
      }
    });
});``