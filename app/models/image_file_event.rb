class ImageFileEvent < ActiveRecord::Base
  belongs_to :image_file
  belongs_to :event, :class_name => 'Category', :foreign_key => 'event_id'

end
