class AddWatermarkData < ActiveRecord::Migration
  def up
    ImageFile.where(:source => 'JumpStart Georgia').update_all(:add_watermark => true)
  end

  def down
    ImageFile.update_all(:add_watermark => false)
  end
end
