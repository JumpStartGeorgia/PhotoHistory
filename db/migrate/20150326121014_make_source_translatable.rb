class MakeSourceTranslatable < ActiveRecord::Migration
  def up
    rename_column :image_files, :source, :old_source
    add_column :image_file_translations, :source, :string
    add_index :image_file_translations, :source

    # move source data to translations table
    ImageFile.transaction do 
      ImageFile.all.each do |img|
        img.image_file_translations.each do |trans|
          trans.source = img.old_source
        end

        img.save
      end
    end
  end

  def down
    remove_index :image_file_translations, :source
    remove_column :image_file_translations, :source, :string
    rename_column :image_files, :old_source, :source
  end
end
