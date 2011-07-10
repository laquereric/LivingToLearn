class UserPrivateController < ApplicationController
  :authenticate_user!
  before_filter :store_context

  def index
  end

end
