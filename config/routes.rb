Rails.application.routes.draw do
   # 追加
  namespace :api do
    namespace :v1 do

      #users_controller
      resources :users, only:[:index,:create]

      #auth_token
      resources :auth_token, only:[:create] do
        post :refresh, on: :collection
        delete :destroy, on: :collection
      end

      #projects
      resources :projects, only:[:index]

      #place
      resources :places, only:[:index,:show]

      #reviews
      resources :reviews, only:[:index,:create,:show,:update,:destroy] do
        get :average, on: :collection
      end
    end
  end
end
