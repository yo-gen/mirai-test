class UsersController < ApplicationController

  def create
    @user = User.new(user_params)
    respond_to do |format|
        if UserCache.new.add_user_to_cache(@user)
          format.html { redirect_to list_user_path(search_by: "id", search_text: @user.id.to_s), notice: 'User was successfully created.' }
        else
          format.html { render :new }
        end
    end
  end

  def add_user
    @user = User.new
  end

  def find_user
  end

  def user_list
    if params[:search_by] == 'id'
      @users = UserCache.new.get_user_by_id(params[:search_text])
    elsif params[:search_by] == "name"
      @users = UserCache.new.get_users_by_name(params[:search_text])
    elsif params[:search_by] == 'pincode'
      @users = UserCache.new.get_users_in_pincode(params[:search_text])
    end
  end
  
  def user_params
    params.require(:user).permit(:id, :name, :pincode)
  end
end