class AddPublishedFieldData < ActiveRecord::Migration
  def up
    Pairing.all.each do |p|
      p.published = true
      p.published_date = p.updated_at
      p.save
    end
  end

  def down
    Pairing.update_all(:published => false, :published_date => nil)
  end
end
