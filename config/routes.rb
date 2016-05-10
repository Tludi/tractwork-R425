Myapp::Application.routes.draw do

  resources :time_punches
  resources :workdays, only: [:index, :show, :new, :create, :update] do
    resources :time_punches
  end
  # resources :projects
  # namespace :admin do
  # get 'users/index'
  # end

  resources :accounts, only: [:new, :create]
  
  namespace :admin do
    root 'dashboard#index'
    resources :accounts do
      resources :users
    end
    resources :users
    
    resources :projects #do
    #   member do
    #     patch :addUser
    #   end
    #   resources :users
    # end
  end

  get 'launchpad' => 'launchpad#index', as: 'launchpad'
  get 'dashboard' => 'dashboard#index', :as => :dashboard

  resources :users, only: [:show]
     
  # get 'user_sessions/new'
  # get 'user_sessions/create'
  # get 'user_sessions/destroy'
  # resources :user_sessions
  resources :user_sessions, only: [:new, :create, :destroy]
  # get 'password_resets/create'
  # get 'password_resets/edit'
  # get 'password_resets/update'
  resources :password_resets, only: [:create, :edit, :update]
  
  get 'login' => 'user_sessions#new', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  # get "home/index"
  # get "home/minor"

  root to: 'launchpad#index'

end
