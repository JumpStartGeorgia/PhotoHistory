class ImageFile < ActiveRecord::Base
	translates :name, :description
  
	has_attached_file :file,
    :url => "/system/images/:id/:converted_basename_:style.:extension",
		:styles => {
					:thumb => {:geometry => "327x233>"},
					:medium => {:geometry => "653x467>"},
					:large => {:geometry => "980x700>"}
				}

	has_many :image_file_translations, :dependent => :destroy
  belongs_to :location_district, :class_name => 'Location', :foreign_key => 'district_id'
  belongs_to :location_special, :class_name => 'Location', :foreign_key => 'special_id'

  accepts_nested_attributes_for :image_file_translations
  attr_accessible :file, :image_file_translations_attributes, :file_content_type, :file_file_size, :file_updated_at, :file_file_name, 
    :year, :lat, :lon, :district, :special, :file_meta, :source, :district_id, :special_id

  validates :file_file_name, :presence => true

	def self.sorted
		with_translations(I18n.locale).order("image_file_translations.name asc, image_files.year asc")
	end
  
  def year_formatted
    self.year.present? ? self.year : I18n.t('app.common.unknown_year')
  end

  def district_name
    location_district.name if self.district_id.present?
  end

  def district_permalink
    location_district.permalink if self.district_id.present?
  end

  def special_name
    location_special.name if self.special_id.present?
  end

  def special_permalink
    location_special.permalink if self.special_id.present?
  end

  # pull out the image width from the image_size value
  def image_width(style)
    x = self.file.image_size(style).split('x').first if self.file_meta.present?
    # if for some reason image size does not exist, return a default value
    if x.nil?
      if style == :medium
        x = 653
      elsif style == :small
        x = 327
      else
        x = 980
      end
    end

    return x
  end
end
