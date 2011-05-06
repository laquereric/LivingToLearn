LivingToLearn::Application.routes.draw do

  devise_for :users
  resources :users, :only => [:index, :show]
  resources :marketing_context_types

  match 'user/:user_id/add_marketing_context/:marketing_context_id', :to => 'users#add_marketing_context', :as => 'add_user_marketing_context'
  match 'user/:user_id/delete_marketing_context/:marketing_context_id', :to => 'users#delete_marketing_context', :as => 'delete_user_marketing_context'
  match 'user/:user_id/select_marketing_context/:marketing_context_id', :to => 'users#select_marketing_context', :as => 'select_user_marketing_context'

  match 'goto/:topic_symbol', :to => 'welcome#goto', :as => 'goto_topic'

  match 'log_into/:email', :to => 'welcome#log_into', :as => 'log_into'

  match '/nj/gc/district_:district_nickname', :to => 'district#site', :as => 'district_site'
  match '/nj/gc/district_:district_nickname/school_:school_nickname', :to => 'school#site', :as => 'school_site'


  root :to => "welcome#index"

end
