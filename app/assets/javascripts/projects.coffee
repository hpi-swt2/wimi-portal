
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

signOutMyselfWarning = (locale, button) ->
  if locale == 'de'
    confirmation =  'Sie sind nicht mehr befugt, weitere Maßnahmen für das Projekt durchzuführen, nachdem Sie sich aus dem Projekt ausgetragen haben!'
  else
    confirmation = 'You will not be able to perform any more actions on the project after you are unenrolled!'
  button.attr('data-confirm', confirmation)
  return

setInactiveWarning = (locale, button) ->
  if locale == 'de'
    confirmation = 'Das Projekt wird nun inaktiv geschalten!'
  else
    confirmation = 'The project will be set as inactive!'
  button.attr('data-confirm', confirmation)
  return confirm

sendLanguageWithButtonToCallback = (clickedButton, callbackWarning) ->
  $.ajax '/users/language',
    success: (res, status, xhr) ->
      callbackWarning res["msg"], clickedButton
      return
    error: (xhr, status, err) ->
      callbackWarning 'en', clickedButton
      return

ready = ->
  if $('#setInactiveButton').length
    sendLanguageWithButtonToCallback $('#setInactiveButton'), setInactiveWarning
  if $('#SignOutMyself').length
    sendLanguageWithButtonToCallback $('#SignOutMyself'), signOutMyselfWarning
  return

$(document).ready ready
$(document).on 'page:load', ready
