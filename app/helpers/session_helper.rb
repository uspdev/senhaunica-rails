module SessionHelper

  #cria uma sessão
  def log_in(loginUsuario)
    session[:usuario_id] = loginUsuario
  end

  #destroi a sessão criada na def anterior
  def log_out
    session.destroy
    @current_user = nil
  end

  #busca um usuário cuja sessão não seja nula (ou seja, tem uma sessão marcada pelo laboratorio.id)
  def current_user
    @current_user ||= Usuario.find_by(loginUsuario: session[:usuario_id])
  end


end
