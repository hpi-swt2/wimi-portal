module ApplicationHelper
  def bootstrap_form_group(form, attribute, &block)
    render(
      partial: 'shared/bootstrap_form_group',
      locals: { form: form, attribute: attribute, block: block }
    )
  end

  def error_class(resource, field_name)
    if resource.errors[field_name].any?
      return "form-error".html_safe
    else
      return "".html_safe
    end
  end
end