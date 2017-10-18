require "rails_helper"

RSpec.describe CardsMailer, type: :mailer do
  describe "unreviewed_cards_email" do
    let(:user) { create(:user) }
    let(:mail) { CardsMailer.unreviewed_cards_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("You have cards to review")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["postmaster@mg.flashcarder.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Welcome")
    end
  end
end
