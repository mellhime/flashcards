require 'spec_helper'
require 'rails_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Флэшкарточкер'" do
      visit root_path
      expect(page).to have_content('Флэшкарточкер')
    end
  end
end
