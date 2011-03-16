class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessiones do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessiones, :session_id
    add_index :sessiones, :updated_at
  end

  def self.down
    drop_table :sessiones
  end
end
