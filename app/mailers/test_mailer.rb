class TestMailer < ApplicationMailer
  def welcome_email
    mail(
      from: 'wakeywakeyapp@outlook.com',
      to: 'jerryvohrer@gmail.com',
      subject: 'Test Email',
      body: 'Hello, world!'
    )
  end
end
