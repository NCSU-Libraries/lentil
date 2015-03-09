Dummy::Application.routes.draw do

  root :to => 'lentil/images#index'

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config.merge(:class_name => 'Lentil::AdminUser')
  mount Lentil::Engine => "/lentil"
end

