class MovePhotographerData < ActiveRecord::Migration
  def up
    ImageFile.transaction do
      ImageFile.where("photographer_old is not null and photographer_old != ''").each do |img|
        puts "photographer = #{img.photographer_old}"
        # if text has '/', assume left side is geo and right is eng
        # otherwise copy text into both locales
        if img.photographer_old.index("/").present?
          puts "- splitting text by '/'"
          ka = img.image_file_translations.select{|x| x.locale == 'ka'}.first
          ka.photographer = img.photographer_old.split("/")[0].strip
          puts "- ka = #{ka.photographer}"
          en = img.image_file_translations.select{|x| x.locale == 'en'}.first
          en.photographer = img.photographer_old.split("/")[1].strip
          puts "- en = #{en.photographer}"
        else
          puts "- saving text to both locales"
          img.image_file_translations.each do |trans|
            trans.photographer = img.photographer_old
          end
        end
        img.save  
      end
    end
  end

  def down  
    ImageFileTranslation.update_all(:photographer => nil)
  end
end
