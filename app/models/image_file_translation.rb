class ImageFileTranslation < ActiveRecord::Base
	belongs_to :image_file

  attr_accessible :image_file_id, :name, :description, :locale, :photographer, :source

  validates :name, :presence => true


end
