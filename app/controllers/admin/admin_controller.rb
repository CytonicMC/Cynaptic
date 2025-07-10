class Admin::AdminController < ApplicationController

  before_action :authenticate!

  attr_reader :current_service, :current_secure_key


  protected

  def authenticate!
    unless authenticate_with_http_token do |token, _options|
      @current_secure_key = SecureKey.find_by_token(token)
      @current_service = @current_secure_key&.owning_service

      unless @current_service
        render json: { error: "Forbidden" }, status: :forbidden
        return
      end

      true
    end
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
