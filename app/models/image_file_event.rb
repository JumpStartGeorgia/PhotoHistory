class ImageFileEvent < ActiveRecord::Base
  belongs_to :image_file
  belongs_to :event, :class_name => 'Category', :foreign_key => 'event_id'

  def self.distinct_event_ids
    select("distinct event_id").where("event_id is not null").map{|x| x.event_id}
  end

end
