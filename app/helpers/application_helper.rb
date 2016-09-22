module ApplicationHelper
  def bootstrap_form_group(form, attribute, &block)
    render(
      partial: 'shared/bootstrap_form_group',
      locals: { form: form, attribute: attribute, block: block }
    )
  end

  def sidebar_actions(&block)
    render(
      partial: 'shared/sidebar_actions_template',f
      locals: { block: block }
    )
  end

  def error_class(resource, field_name)
    if resource.errors[field_name].any?
      return "form-error".html_safe
    else
      return "".html_safe
    end
  end
  
  def can_link_or_else(title, action, model, link_args = {})
    if can? action, model
      url_args = { controller: model.model_name.route_key, action: action}
      url_args[:id] = model unless model.is_a? Class
      link_to(title, url_for(url_args), link_args)
    else
      yield
    end
  end
  
  def can_link(title, action, model, link_args = {})
    can_link_or_else(title, action, model, link_args) { '' }
  end
  
  def action_button(action, model, link_args = {})
    link_args[:class] = 'btn ' + (link_args[:class] || '')
    title = t(".#{action}", default: t("helpers.links.#{action}", model: model.model_name.human.titleize))
    can_link title, action, model, link_args
  end
  
  def show_button(model, link_args = {})
    # <%= link_to t('helpers.links.show', model: model.model_name.human.titleize), chair_path(chair), class: 'btn btn-default btn-xs' %>
    link_args[:class] = 'btn-default ' + (link_args[:class] || '')
    action_button :show, model, link_args
  end
  
  def edit_button(model, link_args = {})
    # <%= link_to t('helpers.links.edit'), edit_chair_path(chair), class: 'btn btn-warning btn-xs' %>
    link_args[:class] = 'btn-warning ' + (link_args[:class] || '')
    action_button :edit, model, link_args
  end
  
  def delete_button(model, link_args = {})
    # <%= link_to t('helpers.links.destroy'), chair_path(id: chair), method: :delete, data: {confirm: t('helpers.links.confirm', default: t("helpers.links.confirm", default: 'Are you sure?'))}, class: 'btn btn-danger btn-xs' %>
    link_args[:method] = :delete
    link_args[:data] = {confirm: t("helpers.links.confirm_delete", default: 'Are you sure?')}
    link_args[:class] = 'btn-danger ' + (link_args[:class] || '')
    action_button :destroy, model, link_args
  end
  
  def create_button(model, link_args = {})
#      <%= link_to t('helpers.titles.new', model: model_class.model_name.human.titleize),
#                  new_chair_path,
#                  class: 'btn btn-success btn-block' %>    
    title = t('helpers.titles.new', model: model.model_name.human.titleize)
    link_args[:class] = 'btn btn-success ' + (link_args[:class] || '')
    can_link title, :new, model, link_args
  end
  
  def entity_link(name, model)
    can_link_or_else(name, :show, model) { name }
  end
  
  def linked_name(model)
    entity_link(model.name, model)
  end
end