class UsersController < ApplicationController

  def dashboard
    skip_authorization
    @user = current_user
    @user = User.find(params[:id])
  end

  def show
    skip_authorization
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile picture updated successfully"
    else
      render :edit
    end
  end

  def update_profile_picture
    @user = User.find(params[:id])
    authorize @user
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def delete_profile_picture
    @user = User.find(params[:id])
    if @user.profile_picture.present?
      # Delete the image from Cloudinary
      Cloudinary::Uploader.destroy(@user.profile_picture)
      # Remove the profile picture from the user record
      @user.profile_picture = nil
      @user.save
      authorize @user
    end
    redirect_to user_path(@user)
  end

  def update_password
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      bypass_sign_in(@user)
      redirect_to user_path(@user), notice: "Password updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :edit_password
    end
  end

  def edit_password
    @user = User.find(params[:id])
    authorize @user
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :profile_picture)
  end
end
