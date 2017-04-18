Rails.application.routes.draw do
  resources :orders
  resources :order_lists
  resources :accounts
  resources :sites
  resources :users
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
