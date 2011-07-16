class SessionsController < Devise::SessionsController
  def new
      respond_to do |format|
        format.html { render :template=>'users/sessions/new'}
        format.iphone { render :template=>'users/sessions/new'}
      end


  end
end

