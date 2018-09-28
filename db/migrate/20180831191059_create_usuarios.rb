class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nomeUsuario
      t.string :loginUsuario
      t.string :tipoUsuario
      t.string :emailPrincipalUsuario
      t.string :emailAlternativoUsuario
      t.string  :emailUspUsuario
      t.string  :numeroTelefoneFormatado
      t.string  :ramalUsp
      t.timestamps null: false
    end
  end
end
