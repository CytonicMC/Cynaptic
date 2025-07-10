class Public::FriendsController < Public::PublicController
  before_action :set_friend, only: :show

  # GET /friends/1
  def show
    render json: { data: @friend }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friend
    @friend = Friend.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def friend_params
    params.fetch(:friend, {})
  end
end
