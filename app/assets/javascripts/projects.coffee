
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



ready = ->
  engine = new Bloodhound(
    datumTokenizer: (d) ->
      console.log d
      Bloodhound.tokenizers.whitespace d.title
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote: url: '../projects/typeahead/%QUERY')
  promise = engine.initialize()
  $('.typeahead').typeahead null,
    name: 'engine'
    displayKey: 'email'
    source: engine.ttAdapter()
  return

$(document).ready ready
$(document).on 'page:load', ready


ready = ->
  $('#SignOutMyself').click ->
    if !@checked
      alert 'You won\'t be able to perform any more actions on the project after you\'re unenrolled!'
    return
  return


$(document).ready ready
$(document).on 'page:load', ready

ready = ->
  $('#setInactiveButton').click ->
    alert 'You\'re going to set the project status to inactive'
  return

$(document).ready ready
$(document).on 'page:load', ready
