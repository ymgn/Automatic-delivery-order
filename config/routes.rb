Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  resources :orders
  resources :order_lists
  resources :accounts
  get "/accounts/:id/item_list", to: "accounts#item_list", as: "account_item_list"
  resources :sites
  # resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # curl注文用
  namespace :delivery do
    get "/:site_code/:order_num" , :action => "index" # 自動で注文する
  end

  # API用
  namespace :api do
    namespace :order_list do
      get "/" , :action => "index"  # 商品リストの番号一覧を取得
    end
  end
end
