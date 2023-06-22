class ApplicationMailer < ActionMailer::Base
  default from: 'clientsupport@gloria-jeans.ru'
  layout 'mailer'
  def subject_prepend
    "[am-dash]"
  end
end
