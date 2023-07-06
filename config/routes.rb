Rails.application.routes.draw do
  get 'newsletter_messages/edit'
  get 'newsletter_messages/update'
  get 'subscriptions/create'
  devise_for :users
  root to: "discovers#index"
  get '/my_events', to: 'events#my_events', as: :my_events
  get "my_bookings", to: "bookings#my_bookings", as: :my_bookings
  resources :discovers, except: [:update]
  resources :events do
    resources :bookings, only: %i[index show create destroy]
  end

  resources :users, only: [] do
    resources :received_messages, only: :create
  end

  resources :users do
    member do
      patch :update_profile_picture
    end
  end

  resources :users do
    member do
      get :edit_password
      put :update_password
      delete :delete_profile_picture
    end
  end

  resources :dashboards
  resources :chatrooms, only: %i[show index create destroy] do
    resources :messages, only: :create
  end
  # get '/users/:id/dashboard', to: 'users#dashboard', as: :dashboard
  post 'subscribe', to: 'subscriptions#create'
  get 'edit_newsletter_message', to: 'newsletter_messages#edit'
  patch 'update_newsletter_message', to: 'newsletter_messages#update'
  get '/audio-content', to: 'dashboards#audio'
  get '/video-content', to: 'dashboards#video'
  get '/images-content', to: 'dashboards#images'
  get 'activity', to: 'messages#index', as: :activity
  get '/users/:id', to: 'users#show', as: :user_id
end
