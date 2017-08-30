class CardsController < ApplicationController
  before_action :find_card, only: [:show, :edit, :update, :destroy, :check]

  def index
    @cards = Card.paginate(page: params[:page])
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to @card
    else
      render 'new'
    end
  end

  def update
    if @card.update_attributes(card_params)
      redirect_to @card
    else
      render 'edit'
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path
  end

  def get_random_card
    @card = Card.can_be_reviewed.sample
  end

  def check
    if params[:card][:original_text] == @card.original_text
      flash[:success] = "Правильно!"
      @card.update_attributes(review_date: Time.now + 259200)
    else
      flash[:danger] = "Неправильно!"
    end
    redirect_to root_path
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end

  def find_card
    @card = Card.find(params[:id])
  end
end
