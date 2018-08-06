class ApplicationMailer < ActionMailer::Base
  default from: ENV["mail_username"]
  layout "mailer"
end
