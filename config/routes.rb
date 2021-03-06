Rails.application.routes.draw do
 get 'homes/index'
 devise_for :users, controllers: {
   omniauth_callbacks: 'users/omniauth_callbacks'
 }

 unauthenticated do
   root 'homes#index', as: :unauthenticated_root
 end

 authenticated do
   root 'users#mypage', as: :authenticated_root
 end

 get 'mypage', to: 'users#mypage'
 get 'mypage/edit', to: 'users#edit'
 patch 'mypage/update', to: 'users#update'
 get 'users/name', to: 'users#name'
 resources :users, only: [:show]

 resources :prots do
   resources :nodes
   resources :reviews do
     resources :comments, only: %i[create update destroy]
   end
 end

 get 'prot/search', to: 'prots#search'

 namespace :preview do
   resources :nodes, only: [:index]
 end

 resources :prot_genres, only: [:destroy]
 resources :prot_media_types, only: [:destroy]

 resources :stars, only: %i[create destroy]
 resources :hearts, only: %i[create destroy]
 resources :goods, only: %i[create destroy]

 mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
