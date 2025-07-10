class Public::PlayersController < Public::PublicController
  before_action :set_player, only: :show

  # GET /players
  def index
    @players = Player.all

    render json: { data: @players.as_json }, status: :ok
  end

  # GET /players/1
  def show
    render json: { data: @player.as_json }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def player_params
    params.fetch(:player, {})
  end
end
