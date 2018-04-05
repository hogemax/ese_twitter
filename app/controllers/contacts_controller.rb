class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.sent(@contact).deliver # 問い合わせ相手にメール送信
      ContactMailer.sent_to_owner(@contact).deliver # 管理者（自分）にメール送信
      flash[:success] = "Thanks!! We'll be in touch."
      redirect_to root_url
    else
      #flash[:alert] = "Input error!"
      render action: :new
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :age, :email, :content)
    end
end
