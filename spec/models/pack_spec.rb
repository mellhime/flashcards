require 'rails_helper'

describe Pack do
  let(:user) { create(:user) }
  let(:pack) { create(:pack, user_id: user.id) }

  subject { pack }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:cards) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when name is not present" do
    before { pack.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when name is too long" do
    before { pack.name = "w" * 36 }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { pack.user_id = nil }
    it { should_not be_valid }
  end

  describe "card associations" do
    before { pack.save }
    let!(:card)  { create(:card, pack: pack) }

    it "should have cards" do
      expect(pack.cards).to include(card)
    end
  end
end
