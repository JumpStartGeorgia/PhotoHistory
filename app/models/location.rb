class Location < ActiveRecord::Base
	translates :name, :permalink

	has_many :location_translations, :dependent => :destroy
  accepts_nested_attributes_for :location_translations
  attr_accessible :type_id, :location_translations_attributes

  validates :type_id, :presence => true
  

  TYPES = {:district => 1, :special => 2}

  def self.by_type(type_id)
    with_translations(I18n.locale).where(:type_id => type_id).order("location_translations.name asc")
  end

  def type_name
    index = TYPES.values.index(self.type_id)
    if index
      I18n.t("activerecord.attributes.image_file.#{TYPES.keys[index]}")
    end
  end

end
