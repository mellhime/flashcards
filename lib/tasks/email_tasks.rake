desc 'send email'

task send_email: :environment do
  User.has_unreviewed_cards.uniq.each do |user|
    CardsMailer.unreviewed_cards_email(user).deliver!
  end
end
