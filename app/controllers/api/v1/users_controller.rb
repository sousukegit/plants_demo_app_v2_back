class Api::V1::UsersController < ApplicationController

    def  index
        user = User.all
        render json: user.as_json(only:[:id,:name,:email,:created_at])
    end
end
