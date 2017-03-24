class ApplicationMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include CanCan::ControllerAdditions

  default from: 'HPI Wimi Portal <hpi.wimiportal@gmail.com>'
  layout 'mailer'
end
