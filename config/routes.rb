require 'api_constraints'

GradshubRails::Application.routes.draw do
  concern :skillable do
    resources :skills, :only => [:index, :create, :show, :destroy] do
      collection do
        put '', to: 'skills#update_collection'
      end
    end
  end

  concern :interestable do
    resources :interests, :only => [:index, :create, :show, :destroy] do
      collection do
        put '', to: 'interests#update_collection'
      end
    end
  end

  concern :password_changeable do
    member do
      put 'password'
    end
  end

  # configure linkedin oauth
  resource :oauth, only: [:linkedin] do
    get :linkedin, on: :member
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
    # We are going to list our resources here
      devise_for :users, :only => []
      resources :employers, :only => [:show, :create, :update], concerns: [:skillable, :interestable, :password_changeable] do
        resources :nationalities, :only => [:index, :create, :show, :destroy]
      end
      resources :candidates, :only => [:show, :create, :update], concerns: [:skillable, :interestable, :password_changeable] do
        resources :experiences, :only => [:index, :create, :update, :destroy, :show]
        resources :educations, :only => [:index, :create, :update, :destroy, :show]
        resources :nationalities, :only => [:index, :create, :show, :destroy]
        resources :languages, :controller => :candidate_languages, :only => [:index, :create, :update, :show, :destroy]
      end
      resources :sessions, :only => [:create, :password_reset_request, :password_reset, :refresh] do
        collection do
          get :password_reset, to: 'sessions#password_reset_request'
          get :refresh, to: 'sessions#refresh'
          post :password_reset, to: 'sessions#password_reset'
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
      resources :interests, :only => [:index, :create, :show]
      resources :communication, :only => [:create]
      resources :companies, :only => [:index, :create]
      resource :image, :only => [:upload] do
        post :upload, on: :member
        delete :delete, on: :member
      end

      resource :search, controller: 'search',  :only => [:show]
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'home#index'
  match '*a', :to => 'errors#routing', via: :all
end
