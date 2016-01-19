sendLanguageToCallback = (callback) ->
  $.ajax '/users/language',
    success: (res, status, xhr) ->
      callback res["msg"]
      return
    error: (xhr, status, err) ->
      callback 'en'
      return

initDatepicker = (lang) ->
  $('.dp').datepicker
    orientation: 'bottom auto'
    autoclose: true
    language: lang
  $('a[rel=\'tooltip\']').tooltip()

ready = ->
  if $('.dp').length
    sendLanguageToCallback initDatepicker
  return

$(document).ready ready
$(document).on 'page:load', ready