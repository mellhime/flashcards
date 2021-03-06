require 'rails_helper'

describe User do
  let(:user) { create(:user) }

  # after(:all) { User.delete_all }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:cards) }
  it { should respond_to(:packs) }
  it { should respond_to(:current_pack) }
  it { should respond_to(:locale) }

  it { should be_valid }

  describe "when name is not present" do
    before { user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { user.name = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email address is already taken" do
    let(:user2) { build(:user, email: user.email) }
    it { expect(user2).not_to be_valid }
  end

  describe "when password is not present" do
    let(:user) { build(:user, password: "") }
    it { expect(user).not_to be_valid }
  end

  describe "when password doesn't match confirmation" do
    let(:user) { build(:user, password_confirmation: "mismatch") }
    it { expect(user).not_to be_valid }
  end

  describe "with a password that's too short" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "card associations" do
    before { user.save }
    let!(:first_card)  { create(:card, user: user) }
    let!(:second_card) { create(:card, user: user) }

    it "should have cards" do
      expect(user.cards.to_a).to eq [first_card, second_card]
    end
  end

  describe "pack associations" do
    before { user.save }
    let!(:first_pack)  { create(:pack, user: user) }
    let!(:second_pack) { create(:pack, user: user) }

    it "should have packs" do
      expect(user.packs.to_a).to eq [first_pack, second_pack]
    end
  end

  describe "setting user's locale" do
    it "should be from user.locale" do
      expect(I18n.locale).to eq(user.locale.to_sym)
    end
  end

  describe "scope has_unreviewed_cards" do
    let(:card) { create(:card, user: user) }

    it "should show user's unreviewed cards" do
      card.update_attributes(review_date: Date.today - 2.days)
      User.has_unreviewed_cards.should include(user)
    end
  end
end
