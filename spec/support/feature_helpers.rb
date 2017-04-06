RSpec::Matchers.define :have_success_flash_message do
  success_flash = 'div.alert-success'
  match do |page|
    page.has_css?(success_flash, visible: true, count: 1)
  end
  failure_message do |page|
    "expected \"#{page.text}\" to include one element matching \"#{success_flash}\"."
  end
  failure_message_when_negated do |page|
    "expected \"#{page.text}\" to not include an element matching \"#{success_flash}\"."
  end
end

RSpec::Matchers.define :have_danger_flash_message do
  danger_flash = 'div.alert-danger'
  match do |page|
    page.has_css?(danger_flash, visible: true, count: 1)
  end
  failure_message do |page|
    "expected \"#{page.text}\" to include one element matching \"#{danger_flash}\"."
  end
  failure_message_when_negated do |page|
    "expected \"#{page.text}\" to not include an element matching \"#{danger_flash}\"."
  end
end

RSpec::Matchers.define :have_delete_link do |model|
  match do |page|
    css_match = "a[data-method='delete'][href='#{polymorphic_path(model)}']"
    page.has_css?(css_match, visible: true, count: 1)
  end
  failure_message do |page|
    css_match = "a[data-method='delete'][href='#{polymorphic_path(model)}']"
    "expected one element matching \"#{css_match}\" in \"#{page.text}\"."
  end
  failure_message_when_negated do |page|
    css_match = "a[data-method='delete'][href='#{polymorphic_path(model)}']"
    "expected no element matching \"#{css_match}\" in \"#{page.text}\"."
  end
end
