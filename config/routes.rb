Lentil::Engine.routes.draw do

  get "thisorthat/battle" => 'thisorthat#battle', :as => :thisorthat_battle
  post "thisorthat/result" => 'thisorthat#result', :as => :thisorthat_result
  get "thisorthat/battle_leaders" => 'thisorthat#battle_leaders', :as => :thisorthat_battle_leaders
  get "images/recent" => 'images#recent', :as => :images_recent
  get "images/popular" => 'images#popular', :as => :images_popular
  get "images/staff_picks" => 'images#staff_picks', :as => :images_staff_picks
  get "images/animate" => 'images#animate', :as => :images_animate
  get "images/staff_picks_animate" => 'images#staff_picks_animate', :as => :staff_picks_animate
  get "images/iframe" => 'images#iframe', :as => :images_iframe
  get "about" => 'pages#about', :as => :pages_about
  post 'like_votes/:image_id' => 'like_votes#tally', :as => :tally_like_vote
  post 'flags/:image_id' => 'flags#tally', :as => :tally_flag
  resources :photographers, :only => [:index, :show]
  resources :images, :only => [:index, :show]

end
