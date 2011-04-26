class WelcomeController < ApplicationController
  layout 'home'

  def index
    if user_signed_in?
      @existing_marketing_context_types =
        current_user.marketing_context_types
      @possible_marketing_context_types =
        MarketingContextType.all_except(@existing_marketing_context_types)
    end
  end

end
