
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

inviteInitUser = (locale) ->
  count = 0
  $('body').on 'click', '#invite_user', ->
    email = $('#invitation_mail').val()
    if validateEmail(email)
      $('#invitation_mail').val('')

      span = document.createElement("span")
      span.id = 'user' + count

      deleteButton = document.createElement("input")
      deleteButton.type = 'RemoveButton'

      if locale == 'en'
        deleteButton.value = 'Remove'
      else
        deleteButton.value = 'Entfernen'

      deleteButton.id = 'delete' + count
      deleteButton.name = 'deleteInvitationButton' + count

      newInvitation = document.createElement("input")
      newInvitation.value = email
      newInvitation.name = 'invitations[' + count + ']'
      newInvitation.type = 'invitationEmail'

      divcol9 = document.createElement('div')
      divcol9.id = 'div9'
      divcol3 = document.createElement('div')
      divcol3.id = 'div3'

      divcol9.appendChild(newInvitation)
      divcol3.appendChild(deleteButton)

      span.appendChild(divcol9)
      span.appendChild(divcol3)

      list = document.getElementById("invited_users")
      list.appendChild(span)

      setTimeout ( ->
        $('#invited_users > span').addClass('col-md-12')
        $('#invited_users > span').css('padding-top', '0px')
        $('#invited_users > span > #div9').addClass('col-md-9')
        $('#invited_users > span > #div3').addClass('col-md-3')
        $('input[type=invitationEmail]').addClass('form-control').attr('readonly', true)
        $('input[type=RemoveButton]').addClass('btn btn-default btn-block')
      ), 5

      count += 1
      $(deleteButton).on 'click',  -> deleteInvitation()
      return
    else
      if locale == 'en'
        alert 'Please enter a valid email adress'
      else
        alert 'Bitte gibt eine valide Email-Adresse ein'

deleteInvitation = ->
  deleteButtonCount = $("input[type=button][clicked=true]").prevObject[0].activeElement.id
  deleteButtonCount = deleteButtonCount.split('delete')[1]

  list = document.getElementById("invited_users")
  elem = document.getElementById("user" + deleteButtonCount)
  list.removeChild(elem)

validateEmail = (email) ->
  re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  re.test email

renderHiwiWorkingHoursCharts = (data) ->
  chart = new (CanvasJS.Chart)('hiwiWorkingHoursChart',
    animationEnabled: true
    legend:
      verticalAlign: 'bottom'
      horizontalAlign: 'center'
    theme: 'theme1'
    data: [ {
      type: 'pie'
      indexLabelFontFamily: 'Garamond'
      indexLabelFontSize: 20
      indexLabelFontWeight: 'bold'
      startAngle: 0
      indexLabelFontColor: 'MistyRose'
      indexLabelLineColor: 'darkgrey'
      indexLabelPlacement: 'inside'
      toolTipContent: '{name}: {y}hrs'
      showInLegend: true
      indexLabel: '{y}'
      dataPoints: data
    } ])
  chart.render()

sendWorkingHoursForMonthYearToRenderer = (monthYear, callback) ->
  $.ajax '/projects/hiwi_working_hours/' + monthYear,
    success: (res, status, xhr) ->
      callback res["msg"]
      return
    error: (xhr, status, err) ->
      callback JSON.parse "{ \"y\": 0, \"name\": \"Error - Try again later | Fehler - Bitte versuchen Sie es später nochmal\"}"
      return

refreshWorkingHoursChart = ->
  month = $('#workingHoursChartMonth').val()
  year = $('#workingHoursChartYear').val()
  sendWorkingHoursForMonthYearToRenderer month + "-" + year, renderHiwiWorkingHoursCharts

initWorkingHoursChart = ->
  today = new Date
  monthDate = today.getMonth() + 1 + "-" + today.getFullYear()
  sendWorkingHoursForMonthYearToRenderer monthDate, renderHiwiWorkingHoursCharts
  $('#workingHoursChartMonth').change ->
    refreshWorkingHoursChart()
  $('#workingHoursChartYear').change ->
    refreshWorkingHoursChart()

ready = ->
  if $('#setInactiveButton').length
    sendLanguageWithButtonToCallback $('#setInactiveButton'), setInactiveWarning
  if $('#SignOutMyself').length
    sendLanguageWithButtonToCallback $('#SignOutMyself'), signOutMyselfWarning
  if $('#invite_user').length
    sendLanguageWithButtonToCallback $('#invite_user'), inviteInitUser
  if $('#hiwiWorkingHoursChart').length
    initWorkingHoursChart()
  return

$(document).ready ready
$(document).on 'page:load', ready
