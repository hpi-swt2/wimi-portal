// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require bootstrap/bootstrap-tooltip
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require select2
//= require canvasjs.min
//= require_tree .

$(document).ready(function() {
  $('.datepicker').datepicker();

  $(".user-auto-complete").select2({
    theme: 'bootstrap',
    allowClear: true,
    placeholder: '',
    ajax: {
      url: function (params) {
        return '/users/autocomplete/' + params.term;
      },
      /* query is in the form /users/autocomplete/<query> */
      data: function (params) {return ''},
      dataType: 'json',
      delay: 250,
      processResults: function (data, params) {
        return {
          results: $.map(data, function(obj){
            return { id: obj.id, text: obj.first_name + ' ' + obj.last_name + ' (' + obj.email + ')'};
          }),
          more: false
        }
      }
    }
  });
});
