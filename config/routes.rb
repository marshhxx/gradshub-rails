require 'api_constraints'

Demo::Application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
    # We are going to list our resources here
      devise_for :users, :only => []
      resources :users, :only => [:show, :create, :update]
      resources :sessions, :only => [:create, :destroy, :password_reset] do
        collection do
          put :password_reset
        end
      end
      resources :languages, :only => [:index]
      resources :schools, :only => [:index]
      resources :countries, :only => [:index], shallow: true do
        resources :states, :only => [:index]
      end
      resources :nationalities, :only => [:index]
      resources :skills, :only => [:index, :create]
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  match '*a', :to => 'errors#routing', via: :all
end
