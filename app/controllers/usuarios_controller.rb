class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]


  # GET /usuarios
  # GET /usuarios.json
  def index

    @usuarios = Usuario.all

=begin

    hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret]}
    @request_token  = OAuth::RequestToken.from_hash(@@consumer, hash)

    @access_token = @request_token.get_access_token(@request_token, oauth_verifier: params[:oauth_verifier])
=end

=begin
    key = "icb_oauth"
    secret = SECRETOAUTH
    @callback_id = "&callback_id=1"

    @consumer = OAuth::Consumer.new(key, secret, {
                                           :site               => "https://uspdigital.usp.br",
                                           :scheme             => :header,
                                           :http_method        => :post,
                                           :request_token_path => "/wsusuario/oauth/request_token",
                                           :access_token_path  => "/wsusuario/oauth/access_token",
                                           :authorize_path     => "/wsusuario/oauth/authorize",
                                           :resource           => "/wusuario/oauth/usuariousp"
                                       })



    @result =  @consumer.request(:post, "https://uspdigital.usp.br/wusuario/oauth/usuariousp", params[:oauth_token])

    #@request_token = @consumer.get_request_token

    print session[:oauth_token]

    print @request_token.to_yaml

    print @result.to_yaml
=end

=begin
    @result =  @acesso.request(:post, "wusuario/oauth/usuariousp/" , session[:oauth_token])

    print @result.to_yaml
=end

=begin
    key = "icb_oauth"
    secret = SECRETOAUTH


    @consumer = OAuth::Consumer.new(key, secret, {
                                           :site               => "https://uspdigital.usp.br",
                                           :scheme             => :header,
                                           :http_method        => :post,
                                           :request_token_path => "/wsusuario/oauth/request_token",
                                           :access_token_path  => "/wsusuario/oauth/access_token",
                                           :authorize_path     => "/wsusuario/oauth/authorize",
                                           :resource           => "/wusuario/oauth/usuariousp"
                                       })



    @result =  @consumer.request(:post, "https://uspdigital.usp.br/wusuario/oauth/usuariousp", session[:oauth_token])

    @access_token = @request_token

    print @access_token

    @userusp = @access_token.gets('/wusuario/oauth/usuariousp')

    print @userusp.to_yaml
=end

    key = "icb_oauth"
    secret = SECRETOAUTH


    @consumer = OAuth::Consumer.new(key, secret, {
                                           :site               => "https://uspdigital.usp.br",
                                           :scheme             => :header,
                                           :http_method        => :post,
                                           :request_token_path => "/wsusuario/oauth/request_token",
                                           :access_token_path  => "/wsusuario/oauth/access_token",
                                           :authorize_path     => "/wsusuario/oauth/authorize",
                                           :resource           => "/wusuario/oauth/usuariousp"
                                       })


    @request_token = @consumer.get_request_token
    @access_token = @request_token.get_access_token
    @result = @access_token.get('/wusuario/oauth/usuariousp')


    print "Retornooooo"
    print @result.to_yaml

  end


  def login

    @callback_id = "&callback_id=1"

    key = "icb_oauth"
    secret = SECRETOAUTH

    @consumer = OAuth::Consumer.new(key, secret, {
                                           :site               => "https://uspdigital.usp.br",
                                           :scheme             => :header,
                                           :http_method        => :post,
                                           :request_token_path => "/wsusuario/oauth/request_token",
                                           :access_token_path  => "/wsusuario/oauth/access_token",
                                           :authorize_path     => "/wsusuario/oauth/authorize"
                                       })


    @request_token = @consumer.get_request_token

    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    redirect_to @request_token.authorize_url + @callback_id

  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to @usuario, notice: 'Usuario was successfully created.' }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to @usuario, notice: 'Usuario was successfully updated.' }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario.destroy
    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: 'Usuario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_usuario
      @usuario = Usuario.find(params[:id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      params.require(:usuario).permit(:nome)
    end
end
