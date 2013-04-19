class FixFileNamesAgain < ActiveRecord::Migration
require 'utf8_converter'
  def up

    ImageFile.all.each do |image|
      puts "image: #{image.id}"
      path = "#{Rails.root}/public/system/images/"
      # update the original file name
      old_name = File.basename(image.file_file_name, File.extname(image.file_file_name)) + "_original"
      new_name = old_name.to_ascii.gsub(/[^0-9A-Za-z_\- ]/,'').split.join('_')
      path << image.id.to_s
      path << "/"
      
      bad_old_name = Utf8Converter.convert_ka_to_en(old_name).to_ascii.gsub(/[^0-9A-Za-z_\- ]/,'').split.join('_')

      if bad_old_name != new_name
        FileUtils.cp(path + bad_old_name + File.extname(image.file_file_name), path + new_name + File.extname(image.file_file_name))
      
        image.file.reprocess!
      end
    end

    # now regenerate the pairing images
    puts "recreating pairing images"
    Pairing.recreate_images
  end

  def down
    # do nothing
  end
end
