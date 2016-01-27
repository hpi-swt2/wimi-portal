
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
    if validateEmail(email)
      $('#invitation_mail').val('')

      span = document.createElement("span")
      span.id = 'user' + count


      deleteButton = document.createElement("input")
      deleteButton.type = 'RemoveButton'
      deleteButton.value = 'Remove'
      deleteButton.id = 'delete' + count
      deleteButton.name = 'deleteInvitationButton' + count

      newInvitation = document.createElement("input")
      newInvitation.value = email
      newInvitation.name = 'invitations[' + count + ']'
      newInvitation.type = 'invitationEmail'



      span.appendChild(newInvitation)
      span.appendChild(deleteButton)

      list = document.getElementById("invited_users")
      list.appendChild(span)

      setTimeout ( ->
        $('#invited_users > span').addClass('col-md-12')
        $('input[type=invitationEmail').addClass('form-control email-invite col-md-2').attr('readonly', true)
        $('input[type=RemoveButton]').addClass('btn btn-default removeButton')

      ), 5

      count += 1

      $(deleteButton).on 'click',  -> deleteInvitation()


      return
    else
      alert 'Please enter a valid email adress'

deleteInvitation = ->
  deleteButtonCount = $("input[type=button][clicked=true]").prevObject[0].activeElement.id
  deleteButtonCount = deleteButtonCount.split('delete')[1]

  list = document.getElementById("invited_users")
  elem = document.getElementById("user" + deleteButtonCount)
  list.removeChild(elem)

validateEmail = (email) ->
  re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  re.test email


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

