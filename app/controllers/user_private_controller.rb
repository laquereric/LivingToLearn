class UserPrivateController < ApplicationController
  before_filter :authenticate_user!
  before_filter :store_context

  def index
      respond_to do |format|
        format.html
        format.iphone
      end
  end

end
