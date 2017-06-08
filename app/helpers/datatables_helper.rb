module DatatablesHelper
  def noscript_bootstrap_element
    content_tag(:noscript) do
      content_tag(:div, t('helpers.no_script_message_html'), class: "alert alert-warning")
    end
  end

  def datatable_tag(tag_args = {})
    searching = tag_args.key?(:searching) ? tag_args[:searching] : true
    info = tag_args.key?(:info) ? tag_args[:info] : true
    content_tag(:table, class: 'table datatable ' + (tag_args[:class] || ''), data: {searching: searching, info: info}) do
      yield
      concat javascript_tag "var datatables_i18n = #{t('datatables').to_json}"
    end
  end

  def datatable_search_input(tag_args = {})
    capture do
      concat noscript_bootstrap_element
      concat content_tag :input, nil, id: 'datatable-search-placeholder', class: 'form-control'
      concat content_tag :span, t('helpers.search.help_text'), class: 'help-block'
    end
  end
end
