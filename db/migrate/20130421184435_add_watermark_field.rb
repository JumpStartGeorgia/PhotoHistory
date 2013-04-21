class AddWatermarkField < ActiveRecord::Migration
  def change
    add_column :image_files, :add_watermark, :boolean, :default => false
  end
end
