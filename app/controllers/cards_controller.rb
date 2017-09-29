class CardsController < ApplicationController
  before_action :find_card, only: [:show, :edit, :update, :destroy, :check]

  def index
    @cards = current_user.cards
  end

  def show; end

  def new
    @card = Card.new
    @packs = current_user.packs
  end

  def edit
    redirect_to cards_path unless current_user.cards.include?(@card)
    @packs = current_user.packs
  end

  def create
    @card = Card.new(card_params.merge(user_id: current_user.id, pack: pack_by_name))
    if @card.save
      redirect_to @card
    else
      render 'new'
    end
  end

  def update
    if @card.update_attributes(card_params.merge(pack: pack_by_name))
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
    choose_card
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
    params.require(:card).permit(:original_text, :translated_text, :review_date, :image, :image_url, :pack)
  end

  def find_card
    @card = Card.find(params[:id])
  end

  def pack_by_name
    current_user.packs.find_by(name: card_params[:pack])
  end

  def choose_card
    @card = if current_user.current_pack.nil?
              current_user.cards.can_be_reviewed.random
            else
              current_user.packs.find_by(id: current_user.current_pack).cards.can_be_reviewed.random
            end
  end
end
