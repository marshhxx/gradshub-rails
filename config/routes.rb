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
      resources :degrees, :only => [:index, :show]
      resources :majors, :only => [:index, :show]
      resources :languages, :only => [:index, :show]
      resources :schools, :only => [:index, :show]
      resources :countries, :only => [:index, :show], shallow: true do
        resources :states, :only => [:index, :show]
      end
      resources :nationalities, :only => [:index, :show]
      resources :skills, :only => [:index, :create, :show]
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  match '*a', :to => 'errors#routing', via: :all
end
