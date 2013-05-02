class CreateImageFileEvents < ActiveRecord::Migration
  def change
    create_table :image_file_events do |t|
      t.integer :image_file_id
      t.integer :event_id

      t.timestamps
    end

    add_index :image_file_events, :image_file_id
    add_index :image_file_events, :event_id
  end
end
