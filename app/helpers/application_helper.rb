module ApplicationHelper
  def bootstrap_form_group(form, attribute, &block)
    render(
      partial: 'shared/bootstrap_form_group',
      locals: { form: form, attribute: attribute, block: block }
    )
  end

  def sidebar_actions(&block)
    render(
      partial: 'shared/sidebar_actions_template',
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
    i18n_key = link_args[:additional_I18n] ? "_#{link_args[:additional_I18n]}" : ''
    title = t(".#{action}", default: t("helpers.links.#{action}#{i18n_key}", model: model.model_name.human.titleize))
    if link_args[:animate]
      link_args[:data] = link_args[:data] || {}
      link_args[:data][:disable_with] = "<i class='fa fa-spinner fa-spin'></i> #{title}".html_safe
    end
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

  # Small version of edit button with short description for use in tables
  def edit_button_table(model, link_args = {})
    link_args[:class] = 'btn-warning btn-xs' + (link_args[:class] || '')
    link_args[:additional_I18n] = 'short'
    action_button :edit, model, link_args
  end
  
  def delete_button(model, link_args = {})
    # <%= link_to t('helpers.links.destroy'), chair_path(id: chair), method: :delete, data: {confirm: t('helpers.links.confirm', default: t("helpers.links.confirm", default: 'Are you sure?'))}, class: 'btn btn-danger btn-xs' %>
    link_args[:method] = :delete
    if(link_args[:confirm].nil?)
      model_class = model.model_name.human.titleize
      identifier = model.respond_to?(:name) ? "#{model_class} #{model.name}" : "#{model_class}"
      link_args[:data] = {confirm: t("helpers.links.confirm_action.message", model: identifier, action: t('helpers.links.confirm_action.delete'), default: 'Are you sure?')}
    else
      link_args[:data] = {confirm: link_args[:confirm]}
    end
    link_args[:class] = 'btn-danger ' + (link_args[:class] || '')
    action_button :destroy, model, link_args
  end
  
  def create_button(model, link_args = {})
#      <%= link_to t('helpers.titles.new', model: model_class.model_name.human.titleize),
#                  new_chair_path,
#                  class: 'btn btn-success btn-block' %>
    if link_args[:title]
      title = link_args[:title]
    else
      title = t('helpers.titles.new', model: model.model_name.human.titleize)
    end
    link_args[:class] = 'btn btn-success ' + (link_args[:class] || '')
    can_link title, :new, model, link_args
  end
  
  def entity_link(name, model)
    can_link_or_else(name, :show, model) { name }
  end
  
  def linked_name(model)
    entity_link(model.name, model)
  end

  def animated_button(label, args = {})
    klass = 'btn ' + (args[:class] || '')
    args[:data] = args[:data] || {}
    args[:data][:disable_with] = "<i class='fa fa-spinner fa-spin'></i> #{label}".html_safe
    button_tag label, class: klass, data: args[:data]
  end

  def timespan_human(total_minutes)
    h, m = total_minutes.divmod(60)
    if m.zero?
      I18n.t('helpers.timespan.hours', hours: h.to_i)
    else
      I18n.t('helpers.timespan.hours_minutes', hours: h.to_i, minutes: m.to_i)
    end
  end

  def status_label_css(status)
    {"created" => "default", "pending" => "primary", "accepted" => "success", "rejected" => "danger", "closed" => "success"}[status]
  end

  def fa(icon_name)
    "<i class=\"fa fa-#{icon_name}\" aria-hidden=\"true\"></i> ".html_safe
  end
end