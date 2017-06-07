module Selectors
  Capybara.add_selector(:linkhref) do
    xpath {|href| ".//a[@href='#{href}']"}
  end

  Capybara.add_selector(:submit) do
    xpath {|href| ".//*[@type='submit']"}
  end
end