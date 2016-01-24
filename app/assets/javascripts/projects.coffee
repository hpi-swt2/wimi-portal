
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


typeahead = ->
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


inviteInitUser = ->
  count = 0
  $('body').on 'click', '#invite_user', ->
    email = $('#invitation_mail').val()
    $('#invitation_mail').val('')

    div = document.createElement("div")
    div.id = 'user' + count

    deleteButton = document.createElement("input")
    deleteButton.type = 'button'
#    deleteButton.addClass("btn btn-danger")
    deleteButton.value = 'Remove Invitation'
    deleteButton.id = 'delete' + count
    deleteButton.name = 'deleteInvitationButton' + count

    newInvitation = document.createElement("input")
    newInvitation.value = email
    newInvitation.name = 'invitations[' + count + ']'

    div.appendChild(newInvitation)
    div.appendChild(deleteButton)

    list = document.getElementById("invited_users")
    list.appendChild(div)
    count += 1

    $(deleteButton).on 'click',  -> deleteInvitation()
    return


deleteInvitation = ->
  deleteButtonCount = $("input[type=button][clicked=true]").prevObject[0].activeElement.id
  deleteButtonCount = deleteButtonCount.split('delete')[1]

  list = document.getElementById("invited_users")
  elem = document.getElementById("user" + deleteButtonCount)
  list.removeChild(elem)



ready = ->
  if $('#setInactiveButton').length
    sendLanguageWithButtonToCallback $('#setInactiveButton'), setInactiveWarning
  if $('#SignOutMyself').length
    sendLanguageWithButtonToCallback $('#SignOutMyself'), signOutMyselfWarning
  if $('.typeahead').length
    typeahead()
  if $('#invite_user').length
    inviteInitUser()
  return


$(document).ready ready
$(document).on 'page:load', ready

