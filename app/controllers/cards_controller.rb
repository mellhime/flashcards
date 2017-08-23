class CardsController < ApplicationController
  
  def new
		@card = Card.new
	end

  def index
  	@cards = Card.all
  end
end
