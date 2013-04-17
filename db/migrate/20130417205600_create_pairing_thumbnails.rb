class CreatePairingThumbnails < ActiveRecord::Migration
  def up
    Pairing.all.each do |p|
      # change the orig id so on save, the thumbnail will be generated cause it thinks something chagned
      p.orig_file1_id = nil
      p.orig_file2_id = nil
      p.save
    end
  end

  def down
    #do nothing
  end
end
