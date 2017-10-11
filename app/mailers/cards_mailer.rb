class CardsMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def unreviewed_cards_email(user)
    @user = user
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'You have cards to review')
  end
end
