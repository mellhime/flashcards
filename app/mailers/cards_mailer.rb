class CardsMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def unreviewed_cards_email(user)
    @user = user
    mail(to: @user.email, subject: 'You have cards to review')
  end
end
