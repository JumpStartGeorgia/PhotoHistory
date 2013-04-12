class Pairing < ActiveRecord::Base
	translates :title, :description, :permalink
  
	has_many :pairing_translations, :dependent => :destroy
  belongs_to :image_file1, :class_name => 'ImageFile', :foreign_key => 'image_file1_id'
  belongs_to :image_file2, :class_name => 'ImageFile', :foreign_key => 'image_file2_id'

  accepts_nested_attributes_for :pairing_translations
  accepts_nested_attributes_for :image_file1
  accepts_nested_attributes_for :image_file2
  attr_accessible :image_file1_id, :image_file2_id, :pairing_translations_attributes, :image_file1_attributes, :image_file2_attributes

  validates :image_file1_id, :image_file2_id, :presence => true

  def self.with_images
    includes(:image_file1, :image_file2).with_translations(I18n.locale)
  end
end
