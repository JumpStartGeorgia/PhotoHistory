class CreatePairings < ActiveRecord::Migration
  def up
    create_table :pairings do |t|
      t.integer :image_file1_id
      t.integer :image_file2_id

      t.timestamps
    end

    add_index :pairings, :image_file1_id
    add_index :pairings, :image_file2_id

    Pairing.create_translation_table! :title => :string, :description => :text, :permalink => :string
    
  end

  def down
    drop_table :pairings
    Pairing.drop_translation_table!
  end
end
