json.extract! usuario, :id, :nome, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
