ready = ->
  engine = new Bloodhound(
    datumTokenizer: (d) ->
      console.log d
      Bloodhound.tokenizers.whitespace d.title
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote: url: '../projects/typeahead/%QUERY')
  promise = engine.initialize()
  promise.done(->
    console.log 'success!'
    return
  ).fail ->
    console.log 'err!'
    return
  $('.typeahead').typeahead null,
    name: 'engine'
    displayKey: 'email'
    source: engine.ttAdapter()
  return

$(document).ready ready
$(document).on 'page:load', ready