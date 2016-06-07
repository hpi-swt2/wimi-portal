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
//= require bootstrap-typeahead-rails
//= require canvasjs.min
//= require_tree .

$('.datepicker').datepicker();

var typeahead = function() {
  var engine = new Bloodhound({
    datumTokenizer: function(d) {
      return Bloodhound.tokenizers.whitespace(d.title);
      console.log(d);
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/users/autocomplete/%QUERY',
      wildcard: '%QUERY'
    }
  });
  engine.initialize();

  var options = {'highlight': true,
                  'hint': true};
  $('.typeahead').typeahead(options, {
    name: 'engine',
    source: engine.ttAdapter(),
    valueKey: function(data){return data.id},
    display: function(data){return data.first_name + ' ' + data.last_name},
    templates: {
      suggestion: function (data) {
        return '<p>' + data.first_name + ' ' + data.last_name + ' <span class="subtle">(' + data.email + ')</span></p>';
      }
    }
  });
};

$(document).ready(function() {
  if ($('.typeahead').length) {
    typeahead();
  }
});


//typeahead = ->
//  engine = new Bloodhound(
//    datumTokenizer: (d) ->
//      console.log d
//      Bloodhound.tokenizers.whitespace d.title
//    queryTokenizer: Bloodhound.tokenizers.whitespace
//    remote: url: '../users/typeahead/%QUERY')
//  promise = engine.initialize()
//  $('.typeahead').typeahead null,
//    name: 'engine'
//    displayKey: 'email'
//    source: engine.ttAdapter()
//  return

