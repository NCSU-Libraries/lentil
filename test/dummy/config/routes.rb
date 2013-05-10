Rails.application.routes.draw do

  root :to => 'lentil/images#index'

  ActiveAdmin.routes(self)
  devise_for :admin_users, :class_name => 'Lentil::AdminUser'
  mount Lentil::Engine => "/lentil"
end

