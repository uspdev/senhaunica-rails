class SessionController < ApplicationController


  def login

    # Parte conceitual: http://oauthbible.com/
    # A USP usa o OAuth 1.0a (Three Legged)

    # 1. Gera objeto consumidor
    @consumer = gera_consumidor

    # 2. Faz a primeira requisição, pegando request token/secret, que serão futuramente trocados por um access_token/secret
    @request_token = @consumer.get_request_token

    # 3. Salva o par de request token/secret gerados na sessão, pois serão usados na troca
    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret

    session[:usuario_id] = nil

    # 4. Envia usuário para URL de autorização
    redirect_to @request_token.authorize_url + @callback_id

  end

  def callback

    # 5. Gera um objeto consumidor - na verdade não precisaria, poderia usar o mesmo, but sorry, I do not know Ruby...
    @consumer = gera_consumidor

    # 6. Gera um hash (tipo um dicionário em python com chave/valor) com os requests token que estão na sessão (passo 3)
    hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret]}

    # 7. Constrói o objeto @request_token para fazermos a troca
    @request_token  = OAuth::RequestToken.from_hash(@consumer, hash)

    # 8. Requisita o access token, passando oauth_verifier retornado via get (Three Legged)
    @access_token = @request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

    # 9. Com posse do access token, faça uma requisição POST
    json_response = @access_token.post("https://uspdigital.usp.br/wsusuario/oauth/usuariousp")
    @data = JSON.parse(json_response.body)

    # 10. Com os dados, seja feliz!! (e claro, salve os dados localmente, faça login do fulano(a), etc etc)
    print @data

    loginUsuario = tratauser

    log_in loginUsuario

  end

  def tratauser

      loginUsuario = @data["loginUsuario"]

      userexiste = Usuario.where(:loginUsuario => loginUsuario)

      if userexiste.empty?
        user = Usuario.new
      else
        user = Usuario.find_by_loginUsuario(loginUsuario)
      end

      user.loginUsuario = loginUsuario
      user.nomeUsuario = @data["nomeUsuario"]
      user.tipoUsuario = @data["tipoUsuario"]
      user.emailPrincipalUsuario = @data["emailPrincipalUsuario"]
      user.emailAlternativoUsuario = @data["emailAlternativoUsuario"]
      user.emailUspUsuario = @data["emailUspUsuario"]
      user.numeroTelefoneFormatado = @data["numeroTelefoneFormatado"]
      user.ramalUsp = @data["ramalUsp"]

      user.save

      id = user.id

      @vinculo = @data["vinculo"]

      @vinculo.each do |v|

        vinculoexiste = TipoVinculo.where(:usuario_id => id, :tipoVinculo => v["tipoVinculo"])

        if vinculoexiste.empty?
          tipoVinc = TipoVinculo.new
        else
          tipoVinc = TipoVinculo.find_by(:usuario_id => id, :tipoVinculo => v["tipoVinculo"] )
        end

          tipoVinc.codigoSetor = v["codigoSetor"]
          tipoVinc.nomeAbreviadSetor = v["nomeAbreviadSetor"]
          tipoVinc.nomeSetor = v["nomeSetor"]
          tipoVinc.codigoUnidade = v["codigoUnidade"]
          tipoVinc.siglaUnidade = v["siglaUnidade"]
          tipoVinc.nomeUnidade = v["nomeUnidade"]
          tipoVinc.nomeVinculo = v["nomeVinculo"]
          tipoVinc.nomeAbreviadoFuncao = v["nomeAbreviadoFuncao"]
          tipoVinc.tipoVinculo = v["tipoVinculo"]
          tipoVinc.usuario_id = id

          tipoVinc.save!

      end

      return loginUsuario

  end


  def gera_consumidor

    @callback_id = ENV['CALLBACK_ID']
    key = ENV['ICB_OAUTH']
    secret = ENV['SECRET_OAUTH']

    return OAuth::Consumer.new(key, secret, {
                                      :site               => "https://uspdigital.usp.br",
                                      :scheme             => :header,
                                      :http_method        => :post,
                                      :request_token_path => "/wsusuario/oauth/request_token",
                                      :access_token_path  => "/wsusuario/oauth/access_token",
                                      :authorize_path     => "/wsusuario/oauth/authorize"
                                  })
  end





  def destroy
    log_out
    redirect_to login_path
  end

end
