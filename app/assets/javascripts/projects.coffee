# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#form_id').submit ->
    if $('#my_check_box_id').prop('checked')
      message = confirm('Are you sure to make this project public?')
      if message
        true
      else
        false
    else
      true
  return