class Admin::ApiKeysController < Admin::AdminController

  # POST /admin/api_keys
  def create

    if ApiKey.exists?(owner: key_params[:owner])
      render json: { error: "#{key_params[:owner]} already has an API key!" }, headers: {}, status: :unprocessable_entity
      return
    end

    @key = ApiKey.new(key_params)

    if @key.save
      response.headers["Authorization"] = @key.raw_token
      puts response.headers["Authorization"]
      render json: @key.as_json(except: :digest), status: :created
    else
      render json: @key.errors, status: :unprocessable_entity
    end
  end

  # GET /admin/api_keys/:id
  def show
    @key = ApiKey.find(params[:id])
    if @key.nil?
      return render json: { error: "No key owned by #{params[:id]} was found" }, status: :not_found
    end
    render json: @key.as_json(except: :digest)
  end

  def index
    render json: ApiKey.all.as_json(except: :digest)
  end

  # DELETE /admin/api_keys/:id
  def destroy
    @key = ApiKey.find(params[:id])
    if @key.nil?
      render json: { error: "No key owned by #{params[:id]} was found" }, status: :not_found
      return
    end
    if @key.destroy
      render json: { message: "#{@key.owner}'s key was successfully deleted." }, status: :ok
    else
      render json: { message: "An error occured whilst deleting #{@key.owner}'s API key." }, status: :internal_server_error
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def key_params
    params.permit(:owner)
  end
end
