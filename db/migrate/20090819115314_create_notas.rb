class CreateNotas < ActiveRecord::Migration
  def self.up
    create_table :notas do |t|
      t.references :origen, :polymorphic => true
      t.string :autor
      t.text :texto

      t.timestamps
    end
  end

  def self.down
    drop_table :notas
  end
end
