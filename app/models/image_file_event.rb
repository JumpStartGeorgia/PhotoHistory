class ImageFileEvent < ActiveRecord::Base
  belongs_to :image_file
  belongs_to :event, :class_name => 'Category', :foreign_key => 'event_id'

  def self.distinct_event_ids
    joins(:image_file => :pairing1s).select("distinct image_file_events.event_id").where("image_file_events.event_id is not null and pairings.published = 1").map{|x| x.event_id}
  end

end
