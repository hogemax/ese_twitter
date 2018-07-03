class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.sent.subject
  #
  default from: ENV['SMTP_MAIL']

  #問い合わせ相手にメール送信
  def sent(contact)
    @contact = contact
    mail(to: @contact.email, subject: "お問い合わせありがとうございます。[自動返信メール]") #do |format|
    #  format.text
    #end
  end

  #管理者（自分）にメール送信
  def sent_to_owner(contact)
    @contact = contact
    mail(to: mail.from, subject: "[#{Rails.env}]お問い合わせがありました。")
  end
end
