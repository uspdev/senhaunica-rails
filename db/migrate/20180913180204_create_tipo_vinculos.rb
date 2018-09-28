class CreateTipoVinculos < ActiveRecord::Migration
  def change
    create_table :tipo_vinculos do |t|

      t.string :tipoVinculo
      t.string :codigoSetor
      t.string :nomeAbreviadSetor
      t.string :nomeSetor
      t.string :codigoUnidade
      t.string :siglaUnidade
      t.string :nomeUnidade
      t.string :nomeVinculo
      t.string :nomeAbreviadoFuncao
      t.references :usuario , index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
