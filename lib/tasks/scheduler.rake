desc "This task is called by the Heroku scheduler add-on"

task send_email: :environment do
  User.has_unreviewed_cards.each do |user|
    CardsMailer.unreviewed_cards_email(user).deliver!
  end
end
