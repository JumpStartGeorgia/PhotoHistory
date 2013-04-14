class ImageFile < ActiveRecord::Base
	translates :name, :description
  
	has_attached_file :file,
    :url => "/system/images/:id/:converted_basename_:style.:extension",
		:styles => {
					:thumb => {:geometry => "230"},
					:medium => {:geometry => "600"},
					:large => {:geometry => "900"}
				}

	has_many :image_file_translations, :dependent => :destroy

  accepts_nested_attributes_for :image_file_translations
  attr_accessible :file, :image_file_translations_attributes, :file_content_type, :file_file_size, :file_updated_at, :file_file_name, 
    :year, :lat, :lon, :district, :special

  validates :file_file_name, :presence => true

	def self.sorted
		with_translations(I18n.locale).order("image_file_translations.name asc, image_files.year asc")
	end
  
  def year_formatted
    self.year.present? ? self.year : I18n.t('app.common.unknown_year')
  end
end
