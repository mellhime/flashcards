class CardsController < ApplicationController
  before_action :find_card, only: [:show, :edit, :update, :destroy, :check]

  def index
    @cards = current_user.cards
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
    redirect_to cards_path unless current_user.cards.include?(@card)
  end

  def create
    @card = Card.new(card_params.merge(user_id: current_user.id))
    if @card.avatar_remote_url.nil?
      flash.now[:danger] = "URL is invalid!"
      render 'new'
    elsif @card.save
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

  def random
    @card = current_user.cards.can_be_reviewed.order("RANDOM()").first
    return @card unless @card.nil?
    flash[:danger] = "Нет карточек для проверки!"
    redirect_to cards_path
  end

  def check
    result = CheckCard.call(user_text: params[:user_text], card: @card)

    if result.success?
      flash[:success] = result.message
    else
      flash[:danger] = result.message
    end
    redirect_to root_path
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :avatar, :avatar_remote_url)
  end

  def find_card
    @card = Card.find(params[:id])
  end
end
