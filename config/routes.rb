Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  get 'committees' => 'home#index', :as => 'home'
  
  get 'committees/committee-types' => 'committee_type#index', :as => 'committee_type_list'
  get 'committees/committee-types/:committee_type' => 'committee_type#show', :as => 'committee_type_show'
  
  get 'committees/committee-categories' => 'committee_category#index', :as => 'committee_category_list'
  get 'committees/committee-categories/:committee_category' => 'committee_category#show', :as => 'committee_category_show'
  
  get 'committees/committees' => 'committee#index', :as => 'committee_list'
  get 'committees/committees/:committee' => 'committee#show', :as => 'committee_show'
  
  get 'committees/houses' => 'house#index', :as => 'house_list'
  get 'committees/houses/:house' => 'house#show', :as => 'house_show'
  
  get 'committees/joint' => 'joint#index', :as => 'joint_list'
  
  get 'committees/departments' => 'department#index', :as => 'department_list'
  get 'committees/departments/:department' => 'department#show', :as => 'department_show'
  
  get 'committees/meta' => 'meta#index', :as => 'meta_list'
  get 'committees/meta/schema' => 'meta#schema', :as => 'meta_schema'
end
