class FixFileNames < ActiveRecord::Migration
require 'utf8_converter'
  def up
    path = "#{Rails.root}/public/system/images/"

    Dir.glob(File.join(path, '**', '**')).each do |file|
      File.rename(file, Utf8Converter.convert_ka_to_en(file))
    end
  end

  def down
    # do nothing
  end
end
