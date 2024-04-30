class Api::V1::HealthCheckController < ApplicationController
    def  index
        render status: 200, json: { message: 'health_check ok' }
    end
end
