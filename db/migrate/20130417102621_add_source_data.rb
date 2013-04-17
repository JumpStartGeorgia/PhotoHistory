class AddSourceData < ActiveRecord::Migration
  def up
    ImageFile.where(:year => 2013).update_all(:source => 'JumpStart Georgia')
  end

  def down
    ImageFile.update_all(:source => nil)
  end
end
