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
//= require dataTables/jquery.dataTables
//= require jquery.turbolinks
//= require jquery.autosize
//= require bootstrap/bootstrap-tooltip
//= require twitter/bootstrap
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.de.js
//= require data-confirm-modal
//= require select2
//= require canvasjs.min
//= require_tree .

$(document).ready(function() {

  /*
   * Datatables configuration
   */
  // https://datatables.net/examples/advanced_init/defaults.html
  $('.datatable').DataTable({
    "paging": false,
    // Show footer on how many rows are displayed currently
    "info": true,
    // No intial ordering
    "order": [],
    // I18n
    // 'datatables_i18n' variable assigned using 'datatable_tag'
    // helper (app/helpers/datatable_helper.rb)
    language: window.datatables_i18n ? datatables_i18n : {}
  });

  // Move datatables search field to element
  // '#datatable-search-placeholder' (if it exists).
  // It's created using the 'datatable_search_input' helper
  // (app/helpers/datatable_helper.rb)
  // Warning: Only works with a single datatable per page
  $placeholder = $("#datatable-search-placeholder")
  if ($placeholder.length) {
    $placeholder.replaceWith(
      $(".dataTables_filter")
        .detach()
        .find("label input")
        .attr("class", $placeholder.attr("class"))
    );
  } else {$
    $('.dataTables_filter input').addClass('form-control');
  }

  /*
   * ConfirmModal defaults
   */
  dataConfirmModal.setDefaults({
    title: $('div.page-header').text(),
    commitClass: 'btn-primary fa fa-lg fa-check',
    cancelClass: 'btn-default fa fa-lg fa-times',
    commit: '',
    cancel: ''
  });

  /*
   * Select2 configuration
   */
  $(".user-auto-complete").select2({
    theme: 'bootstrap',
    allowClear: true,
    placeholder: '',
    ajax: {
      url: function (params) {
        return '/users/autocomplete/' + params.term;
      },
      // query is in the form /users/autocomplete/<query>
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

  /*
   * Autosize JQuery plugin configuration
   */
  $('textarea[data-enable-autosize="true"]').autosize();

  /*
   * Enable toggling visibility with Javascript
   */
  $('*[data-toggle-visibility="true"]').click(function(event) {
    if ($(this).prop('tagName') != 'INPUT') { event.preventDefault(); }
    // Bootstrap class for visibility
    $('.' + $(this).attr('data-target-class')).toggleClass("hidden");
  });

  /*
   * Enable making buttons to POST routes (i.e. forms that make POST requests in Rails 4)
   * created with the 'button_to' helper submit via JS, without reloading the page
   * The table row the button was in can be optionally also removed
   */
  $('input[type="submit"][data-toggle="js-submit"]').click(function(event) {
    // Do not execute the default action of submitting the form and reloading the page
    event.preventDefault();
    // If the 'data-row-remove' attribute is set, get the closest tr, otherwise remove nothing
    var $rowToRemove = $(this).attr('data-row-remove') ? $(this).closest('tr') : '';
    $.post($(this.form).attr('action'))
      .fail(function(e) { console.error('ERROR: ', e) })
      .done(function() {
        $rowToRemove.remove();
      })
  });

});
