# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#currentUserCheckbox').change ->
    if !@checked
      alert 'You won\'t be able to perform any more actions on the project after you\'re unenrolled!'
    return
  return

$(document).ready(ready)
$(document).on('page:load', ready)