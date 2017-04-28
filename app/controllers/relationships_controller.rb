class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = params[:title]
    @user = User.find_by id: params[:user_id]
    if @user.nil?
      flash[:error] = t "user_not_found"
      redirect_to root_path
    else
      @users = @user.send(@title).paginate page: params[:page]
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
      relationship @user
    else
      flash[:error] = t "user_not_found"
      redirect_to root_path
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
    relationship @user
  end

  private
  def relationship user
    @relationship = if current_user.following? user
      current_user.active_relationships.find_by followed_id: @user.id
    else
      current_user.active_relationships.build
    end
  end
end
