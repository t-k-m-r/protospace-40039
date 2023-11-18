class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_prototype, only: [:show, :update, :destroy]


  def index
    @users = User.all
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(@prototype.user_id)
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
    unless Prototype.find(params[:id]).user.id == current_user.id
      redirect_to root_path
    else
      @prototype = Prototype.find(params[:id])
    end
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(params[:id])
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @prototype.destroy
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end