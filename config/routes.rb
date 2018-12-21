Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :links, only: [:show, :create]

  get 'top', to: 'links#top', as: 'top_links'
end
