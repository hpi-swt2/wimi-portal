@toggleField = (field,checkbox) ->
  field.readOnly = checkbox.checked
  field.value = "" if checkbox.checked
  field.placeholder = if checkbox.checked then "Deutschland" else ""
