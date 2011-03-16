class CreateDocumentos < ActiveRecord::Migration
  def self.up
    create_table :documentos do |t|
      t.integer :size
      t.string :content_type, :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :documentos
  end
end
