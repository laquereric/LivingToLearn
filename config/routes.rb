LivingToLearn::Application.routes.draw do

  devise_for :users
  resources :users, :only => [:index, :show]
  resources :marketing_context_types

  match 'user/:user_id/add_marketing_context/:marketing_context_id', :to => 'users#add_marketing_context', :as => 'add_user_marketing_context'

  match 'user/:user_id/delete_marketing_context/:marketing_context_id', :to => 'users#delete_marketing_context', :as => 'delete_user_marketing_context'

  root :to => "welcome#index"

end
