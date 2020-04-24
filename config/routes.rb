# frozen_string_literal: true

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

Rails.application.routes.draw do

  get 'status/health', to: 'status#health'
  get 'status/readiness', to: 'status#readiness'

  namespace :recryptrequests do
    get 'new_ldap_password'
    post 'recrypt'
  end

  resources :teams do
    resources :groups, except: [:index]
    resources :api_users, only: [:index, :create, :destroy], module: 'api/team'
    resources :teammembers
  end

  resources :accounts, except: [:index] do
    member do
      put 'move', to: 'accounts#move'
    end
    resources :items
  end

  get 'session/login_keycloak', to: 'session#login_keycloak'
  get 'session/new', to: 'session#new'
  post 'session', to: 'session#create'
  get 'session/destroy', to: 'session#destroy'
  get 'session/show_update_password', to: 'session#show_update_password'
  post 'session/update_password', to: 'session#update_password'
  post 'session/locale', to: 'session#changelocale'

  get 'wizard', to: 'wizard#index'
  post 'wizard/apply'

  get 'search', to: 'search#index'

  root to: 'search#index'

  get 'changelog', to: 'changelog#index'

  get 'profile', to: 'profile#index'

end
