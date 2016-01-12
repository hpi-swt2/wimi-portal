
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
      url = document.URL
      locale = url.split('?')[1].split('=')[1]
      if locale == 'de'
        alert 'Sie sind nicht mehr befugt, weitere Maßnahmen für das Projekt durchzuführen, nachdem Sie sich aus dem Projekt ausgetragen haben!'
      else
        alert 'You won\'t be able to perform any more actions on the project after you\'re unenrolled!'
      return
    return
  return


$(document).ready ready
$(document).on 'page:load', ready

ready = ->
  $('#setInactiveButton').click ->
    url = document.URL
    locale = url.split('?')[1].split('=')[1]
    if locale == 'de'
      alert 'Das Projekt wird nun inaktiv geschalten!'
    else
      alert 'You\'re going to set the project status to inactive'
    return
  return

$(document).ready ready
$(document).on 'page:load', ready
