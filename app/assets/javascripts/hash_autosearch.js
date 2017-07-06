$(document).ready(function() {
    var search_fields = $('input[type=search');
    var datatable = $('.datatable');
    var hash = window.location.hash;
    if(hash && search_fields.length == 1 && datatable.length == 1) {
        // whitespace is illegal in urls, so we seperate with _ instead
        // however for e.g. forename_lastname we need to transform that back
        hash = hash.substr(1);
        hash = hash.split("_");
        if(hash.length > 1) {
            hash = hash[0] + " " + hash[1];
        }
        search_fields.val(hash);
        datatable.dataTable().fnFilter(hash);
    }
});
