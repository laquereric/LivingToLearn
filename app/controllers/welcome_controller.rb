class WelcomeController < ApplicationController
  layout 'home'
  before_filter :get_marketing_contexts

  def get_marketing_contexts
    if user_signed_in?
      @existing_marketing_context_types =
        current_user.marketing_context_types
      @possible_marketing_context_types =
        MarketingContextType.all_except(@existing_marketing_context_types)
    end
  end

  def goto
    @goto_topic_symbol = params[:topic_symbol]
    session[:goto_topic_symbol]= @goto_topic_symbol
    render "index"
  end

  def index
    session.delete(:goto_topic_symbol)
  end

end
