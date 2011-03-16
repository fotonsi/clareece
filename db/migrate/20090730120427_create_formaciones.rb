class CreateFormaciones < ActiveRecord::Migration
  def self.up
    create_table :formaciones do |t|
      t.references :alumno, :polymorphic => true
      t.references :curso
      t.string :estado
      t.text :observaciones

      t.timestamps
    end
  end

  def self.down
    drop_table :formaciones
  end
end
