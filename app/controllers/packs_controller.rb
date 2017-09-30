class PacksController < ApplicationController
  before_action :find_pack, only: [:show, :edit, :update, :destroy]

  def index
    @packs = current_user.packs
  end

  def show; end

  def new
    @pack = Pack.new
  end

  def edit
    redirect_to packs_path unless current_user.packs.include?(@pack)
  end

  def create
    @pack = Pack.new(pack_params.merge(user_id: current_user.id))
    if @pack.save
      update_current_pack
      redirect_to @pack
    else
      render 'new'
    end
  end

  def update
    if @pack.update_attributes(pack_params)
      update_current_pack
      redirect_to @pack
    else
      render 'edit'
    end
  end

  def destroy
    @pack.destroy
    redirect_to packs_path
  end

  private

  def pack_params
    params.require(:pack).permit(:name, :current)
  end

  def find_pack
    @pack = Pack.find(params[:id])
  end

  def update_current_pack
    current_user.update_attributes(current_pack_id: @pack.id) if pack_params[:current]
  end
end
