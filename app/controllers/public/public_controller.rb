class Public::PublicController < ApplicationController
  before_action :initialize_warnings
  rate_limit to: 30, within: 5.minute, by: -> { request.remote_ip },
             with: -> { render json: { message: "You've reached the ratelimit! Supply an API key in the `Authorization` header to increase your limit!" }, status: :too_many_requests },
             unless: :authenticated?
  rate_limit to: 300, within: 5.minutes, by: -> { request.remote_ip },
             with: -> { render json: { message: "You've reached the ratelimit!" }, status: :too_many_requests },
             if: :authenticated?

  attr_reader :current_owner, :current_api_key

  def render(options = nil, extra_options = {}, &block)
    if options.is_a?(Hash) && options[:json].is_a?(Hash) && @warnings.present?
      options[:json][:warnings] ||= []
      options[:json][:warnings] = @warnings
    end

    super(options, extra_options, &block)
  end

  protected

  def authenticated?
    authenticate_with_http_token do |token|
      @current_api_key = ApiKey.find_by_token(token)
      @current_owner = @current_api_key&.owner

      unless @current_owner
        puts "Invalid API key"
        @warnings << "Invalid API key. Public rate limits apply."
        return false
      end

      return true
    end

    @warnings << "No API key supplied. Public rate limits apply."
    false
  end

  def initialize_warnings
    @warnings = Set.new
  end
end
