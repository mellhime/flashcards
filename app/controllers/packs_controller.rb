class PacksController < ApplicationController
  before_action :find_pack, only: [:show, :edit, :update, :destroy]

  def index
    @packs = current_user.packs
  end

  def show
  end

  def new
    @pack = Pack.new
  end

  def edit
    redirect_to packs_path unless current_user.packs.include?(@pack)
  end

  def create
    @pack = Pack.new(pack_params.merge(user_id: current_user.id))
    check_current
    if @pack.save
      redirect_to @pack
    else
      render 'new'
    end
  end

  def update
    check_current
    if @pack.update_attributes(pack_params)
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

  def check_current
    if pack_params[:current]
      current_user.packs.map { |pack| pack.update_attributes(current: false) }
    end
  end
end
