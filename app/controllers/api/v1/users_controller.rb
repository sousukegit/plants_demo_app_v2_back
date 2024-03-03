class Api::V1::UsersController < ApplicationController
    before_action :authenticate_active_user

    def  index
        #suser = User.all
        puts(cookies[:mode])
        puts(cookies[:mode])
        render json: current_user.as_json(only:[:id,:name,:email,:created_at])
    end
end
