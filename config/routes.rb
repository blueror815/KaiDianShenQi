require 'api_constraints'

CaoWuApi::Application.routes.draw do
  resources :promotions do
    collection do
      post :test_sms
    end
  end

  resources :employees
  resources :settings

  resources :products

  get 'w_retailers/:id' => 'retailers#show'
  get 'home/index'
  get 'home/membership_audit'
  get 'home/product_audit'
  root to: 'home#index'

  devise_for :retailers, path: '/w_retailer'
  resources :members, path: '/w_members' do
    member do
      post :add_tag
    end
    collection do
      post :listing
      get :introduce
      post :award
    end
  end

  get 'analysis', to: 'analysis#index'
  get 'analysis/show', to: 'analysis#show'
  get 'analysis/day', to: 'analysis#day_view'
  get 'analysis/week', to: 'analysis#week_view'
  get 'analysis/month', to: 'analysis#month_view'

  mount SabisuRails::Engine => "/sabisu_rails"
  namespace :api, defaults: {format: :json}, path: '/' do
    scope module: :v1,
      constraints: ApiConstraints.new(version: 1, default: true) do
      
      # https://github.com/kurenn/market_place_api/issues/8
      # devise_for :retailers,  :controller => {:registrations => 'registrations'}
      # and uncomment registrations_controller.rb
      # and remove ":create" below for retailers
      resources :awards, only: [:create]

      resources :retailers, :only => [:show, :create] do
        collection do
          get :profile_qr_image
        end
        resources :products, :except => [:edit]
        resources :orders, :only => [:create, :index, :show]
        resources :orders do
          collection do
            post 'create_points_order'
          end
        end
      end

      resources :retailers do
        member do
          post 'find_and_show_membership'
          post 'add_points_to_member'
          post 'show_sign_up'
        end
      end



      resources :members, :only => [:create] do
        collection do
          post 'show_my_retailers'
        end
        collection do
          post 'associate_client_id'
        end
        collection do
          post 'destroy_client_id'
        end
      end
      resources :retailer_sessions, :only => [:create, :destroy]
      resources :member_sessions, :only => [:create, :destroy]

      devise_for :retailers
      devise_for :members
    end
  end
end
