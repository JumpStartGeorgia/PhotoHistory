class FixFileNamesAgain < ActiveRecord::Migration
  def up
    path = "#{Rails.root}/public/system/images/"

    Dir.glob(File.join(path, '**', '*.jpg')).each do |file|
      ary = File.split(file)
      ary[1] = File.basename(file, File.extname(file)).to_ascii.gsub(/[^0-9A-Za-z_\- ]/,'').split.join('_')
      ary[1] << File.extname(file)
      File.rename(file, ary.join("/"))
    end

    # now regenerate the pairing images
    Pairing.recreate_images
  end

  def down
    # do nothing
  end
end
