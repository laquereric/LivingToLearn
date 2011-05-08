LivingToLearn::Application.routes.draw do

  devise_for :users
  resources :users, :only => [:index, :show]
  resources :marketing_context_types

  match 'user/:user_id/add_marketing_context/:marketing_context_id', :to => 'users#add_marketing_context', :as => 'add_user_marketing_context'
  match 'user/:user_id/delete_marketing_context/:marketing_context_id', :to => 'users#delete_marketing_context', :as => 'delete_user_marketing_context'
  match 'user/:user_id/select_marketing_context/:marketing_context_id', :to => 'users#select_marketing_context', :as => 'select_user_marketing_context'

  match 'goto/:topic_symbol', :to => 'welcome#goto', :as => 'goto_topic'

  match 'log_into/:email', :to => 'welcome#log_into', :as => 'log_into'

################

  match '/nj/gc/district_:district_nickname/site', :to => 'district#site', :as => 'district_site'

  match '/nj/gc/district_:district_nickname/school_:school_nickname/site', :to => 'school#site', :as => 'school_site'

################

  match '/nj/gc/district_:district_nickname/character_book', :to => 'character#district', :as => 'district_character_page'

  match '/nj/gc/district_:district_nickname/school_:school_nickname/character_book', :to => 'character#school', :as => 'school_character_book'

  match '/nj/gc/district_:district_nickname/school_:school_nickname/character_book/content_area_:content_area_code/standard_code_:standard_code', :to => 'character#standard', :as => 'school_character_book_standard'

  match '/nj/gc/district_:district_nickname/school_:school_nickname/character_book/content_area_:content_area_code/standard_:standard_code/strand_:strand_code', :to => 'character#strand', :as => 'school_character_book_strand'

#################

  match '/nj/gc/district_character_book_pages', :to => 'district#character_book_pages', :as => 'district_character_book_pages'


#  match '/nj/gc/district_:district_nickname/school_:school_nickname/character_standard/:curriculum_standard_code', :to => 'curriculum#school_character_standard', :as => 'school_character_standard'
# match '/nj/gc/district_:district_nickname', :to => 'district#site', :as => 'district_site'
#  match '/nj/gc/district_:district_nickname/school_:school_nickname', :to => 'school#site', :as => 'school_site'


  root :to => "welcome#index"

end
