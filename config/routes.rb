Rails.application.routes.draw do
   # 追加
  namespace :api do
    namespace :v1 do
      # api test action
      resources :hello, only:[:index]
      #users_controller
      resources :users, only:[:index]
      #auth_token
      resources :auth_token, only:[:create] do
        post :refresh, on: :collection 
        delete :destroy, on: :collection        
      end
      #projects
      resources :projects, only:[:index] 
    end
  end
end
