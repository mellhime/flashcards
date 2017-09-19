require 'rails_helper'

RSpec.describe OauthsController do
  describe "#callback" do
    it 'logs in a linked user' do
      OauthsController.any_instance.should_receive(:login_from).with('google').and_return(Authentication.new)
      user = create(:user)
      session[:user_id] = user.id
      get :callback, params: { provider: 'google', code: '123' }

      expect(flash[:notice]).to be_present
    end

    it 'displays an error if user is not logged in and their google account is not linked' do
      OauthsController.any_instance.should_receive(:login_from).and_return(false)

      get :callback, params: { provider: 'google', code: '123' }
      expect(flash[:alert]).to be_present
    end

    xit 'should create user' do
      OauthsController.any_instance.should_receive(:create_from).with('google').and_return(User.create)
      user = create(:user)
      session[:user_id] = user.id
      get :callback, params: { provider: 'google', code: '1234' }

      expect(flash[:notice]).to be_present
    end
  end
end
