class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEVISE_MAILER_SENDER', 'noreply@nexproject.app')
  layout "mailer"
end
