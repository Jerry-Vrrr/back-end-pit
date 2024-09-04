# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: 'wakeywakeyapp@outlook.com' # Use your default "from" address here
  layout 'mailer'
end
