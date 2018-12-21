# frozen_string_literal: true

Rails.application.routes.draw do
  resources :links, only: %i[show create]

  get 'top', to: 'links#top', as: 'top_links'
end
