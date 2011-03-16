class CreateAdjuntos < ActiveRecord::Migration
  def self.up
    create_table :adjuntos do |t|
      t.integer :size, :width, :height, :db_file_id, :parent_id
      t.string :content_type, :filename, :thumbnail, :parent_type
      t.binary :data

      t.timestamps
    end
  end

  def self.down
    drop_table :adjuntos
  end
end
