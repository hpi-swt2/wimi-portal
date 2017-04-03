
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
  if $('#hiwiWorkingHoursChart').length
    initWorkingHoursChart()
  return

$(document).ready ready
$(document).on 'page:load', ready
