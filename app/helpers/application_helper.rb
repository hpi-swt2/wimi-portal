module ApplicationHelper
  def bootstrap_form_group(form, attribute, &block)
    render(
      partial: 'shared/bootstrap_form_group',
      locals: { form: form, attribute: attribute, block: block }
    )
  end
end