class Category < ActiveRecord::Base
	translates :name, :permalink

	has_many :category_translations, :dependent => :destroy
  accepts_nested_attributes_for :category_translations
  attr_accessible :type_id, :category_translations_attributes

  validates :type_id, :presence => true
  

  TYPES = {:district => 1, :place => 2, :event => 3}

  def self.by_type(type_id)
    with_translations(I18n.locale).where(:type_id => type_id).order("category_translations.name asc")
  end

  def type_name
    index = TYPES.values.index(self.type_id)
    if index
      I18n.t("categories.#{TYPES.keys[index]}")
    end
  end

end