Rails.application.routes.draw do
  root 'dashboard#index'

  get 'saml/init'
  post 'saml/consume'
end
