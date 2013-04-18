class CreateStackedImgs < ActiveRecord::Migration
  def up
    Pairing.recreate_images
  end

  def down
    #do nothing
  end
end
