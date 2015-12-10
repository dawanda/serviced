class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def create
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.save
  end

  def destroy
    user = User.find(params[:id])
    user.delete
    user.save
  end
end
