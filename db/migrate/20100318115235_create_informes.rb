class CreateInformes < ActiveRecord::Migration
  def self.up
    create_table :informes do |t|
      t.string :objeto, :content_type, :filename, :thumbnail
      t.integer :size, :parent_id, :width, :height, :db_file_id
      t.timestamps
    end
  end

  def self.down
    drop_table :informes
  end
end
