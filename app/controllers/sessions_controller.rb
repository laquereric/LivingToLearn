class SessionsController < Devise::SessionsController

  def new
      respond_to do |format|
        format.html { render :template=>'users/sessions/new'}
        format.iphone { render :template=>'users/sessions/new'}
      end
  end

  def create
      respond_to do |format|
        format.html { redirect_to stored_location_for(:user) || user_private_path(:format=>'html') }
        format.iphone { redirect_to stored_location_for(:user) || user_private_path(:format=>'iphone') }
      end
  end

  def destroy
      set_flash_message :notice, :signed_out
      sign_out @user
      respond_to do |format|
        format.html { redirect_to '/.html' }
        format.iphone { redirect_to '/.iphone'}
      end
  end

end

