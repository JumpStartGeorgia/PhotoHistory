class CreateYearRanges < ActiveRecord::Migration
  def up
    create_table :year_ranges do |t|
      t.integer :start
      t.integer :end
      t.integer :sort, :default => 0

      t.timestamps
    end

    add_index :year_ranges, :sort

    YearRange.create_translation_table! :title => :string, :permalink => :string

    add_index :year_range_translations, :permalink
    add_index :year_range_translations, :title
  end

  def down
    drop_table :year_ranges
    YearRange.drop_translation_table!
  end

end
