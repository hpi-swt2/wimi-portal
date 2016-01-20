$ ->
  $('.dp').datepicker
    orientation: 'bottom auto'
    autoclose: true
    language: document.URL.split('?')[1].split('=')[1]
  $('a[rel=\'tooltip\']').tooltip() 
