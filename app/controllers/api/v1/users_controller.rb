class Api::V1::UsersController < ApplicationController
    before_action :authenticate_active_user, only: [:index]

    def  index
        render json: current_user.as_json(only:[:id,:name,:email,:created_at])
    end

    def create
        puts(params)
        @user = User.new(user_params)
        #メール認証の設計にしていたが、スキップする
        @user.activated = true        
        if @user.save
            render json: { message: 'User created successfully' }, status: :created
        else
            puts( @user.errors.full_messages)
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # パラメータの許可設定
    def user_params
        params.require(:user).permit(:name, :email, :password)
    end

end
