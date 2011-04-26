class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def add_marketing_context
    @user = User.find(params[:user_id])
    @user.add_marketing_context(params[:marketing_context_id])
    redirect_to :controller => 'welcome' , :action => :index
  end

end
