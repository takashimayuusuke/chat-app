Rails.application.routes.draw do
  devise_for :users
  root to: "rooms#index"
  resources :users, only: [:edit, :update]
  resources :rooms, only: [:new, :create,:destroy] do
    # ルーティングのネストによってroomsが親、messagesが子になる。(チャットルームに属しているメッセージ)
    resources:messages,only: [:index, :create]
  end
end
