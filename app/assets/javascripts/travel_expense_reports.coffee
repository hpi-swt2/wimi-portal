@toggleField = (div,field,checkbox) ->
  div.style.display = if checkbox.checked then "none" else "block"
  field.value = "" if checkbox.checked
