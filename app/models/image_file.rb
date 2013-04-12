class ImageFile < ActiveRecord::Base
	translates :name, :description
  
	has_attached_file :file,
    :url => "/system/images/:id/:basename_:style.:extension",
		:styles => {
					:thumb => {:geometry => "230x230#"},
					:medium => {:geometry => "600x>"},
					:large => {:geometry => "900x>"}
				}

	has_many :image_file_translations, :dependent => :destroy

  accepts_nested_attributes_for :image_file_translations
  attr_accessible :file, :image_file_translations_attributes, :file_content_type, :file_file_size, :file_updated_at, :file_file_name, 
    :year, :lat, :lon

  validates :file_file_name, :year, :presence => true

end
