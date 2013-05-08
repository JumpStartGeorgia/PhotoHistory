class AddPublishedFieldData < ActiveRecord::Migration
  def up
    Pairing.update_all(:published => true, :published_date => Time.now)
  end

  def down
    Pairing.update_all(:published => false, :published_date => nil)
  end
end
