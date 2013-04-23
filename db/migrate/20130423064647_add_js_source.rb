# encoding: UTF-8
class AddJsSource < ActiveRecord::Migration
  def up
    ImageFile.transaction do
      ImageFile.where(:year => 2013).update_all(:source => 'JumpStart Georgia', :add_watermark => true)

      ids = ImageFile.select("id").where(:year => 2013).map{|x| x.id}

      ImageFileTranslation.where(:image_file_id => ids, :locale => 'ka').update_all(:photographer => 'ირაკლი ჭუმბურიძე')
      ImageFileTranslation.where(:image_file_id => ids, :locale => 'en').update_all(:photographer => 'Irakli Chumburidze')
    end
  end

  def down
    # do nothing
  end
end
