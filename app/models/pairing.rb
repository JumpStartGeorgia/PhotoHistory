# encoding: UTF-8
class Pairing < ActiveRecord::Base
	translates :title, :description, :permalink

	has_attached_file :thumbnail,
    :url => "/system/images/pairings/thumbnails/:id.:extension"
	has_attached_file :stacked_img,
    :url => "/system/images/pairings/stacked_imgs/:id.:extension"
  
	has_many :pairing_translations, :dependent => :destroy
  belongs_to :image_file1, :class_name => 'ImageFile', :foreign_key => 'image_file1_id'
  belongs_to :image_file2, :class_name => 'ImageFile', :foreign_key => 'image_file2_id'

  accepts_nested_attributes_for :pairing_translations
  accepts_nested_attributes_for :image_file1
  accepts_nested_attributes_for :image_file2
  attr_accessible :image_file1_id, :image_file2_id, :pairing_translations_attributes, :image_file1_attributes, :image_file2_attributes,
    :thumbnail, :thumbnail_content_type, :thumbnail_file_size, :thumbnail_updated_at, :thumbnail_file_name,
    :stacked_img, :stacked_img_content_type, :stacked_img_file_size, :stacked_img_updated_at, :stacked_img_file_name

	attr_accessor :orig_file1_id, :orig_file2_id

  validates :image_file1_id, :image_file2_id, :presence => true

	after_find :save_original_ids
  before_save :generate_images
  after_save :delete_generated_images

  def self.with_images
    includes(:image_file1, :image_file2).with_translations(I18n.locale)
  end

  def self.sorted
    joins(:image_file1, :pairing_translations).where(:pairing_translations => {:locale => I18n.locale})
    .order("if(isnull(image_files.year), 1,0) asc, image_files.year asc, pairing_translations.title asc")
  end


  # recreate the images for all pairings
  def self.recreate_images
    Pairing.all.each do |p|
      # change the orig id so on save, the thumbnail will be generated cause it thinks something chagned
      p.orig_file1_id = nil
      p.orig_file2_id = nil
      p.save
    end
  end

protected
  def save_original_ids
    self.orig_file1_id = self.image_file1_id if self.has_attribute?(:image_file1_id)
    self.orig_file2_id = self.image_file2_id if self.has_attribute?(:image_file2_id)
  end

  def temp_thumbnail_path
    "#{Rails.root}/tmp/pairing_thumb_#{self.id}.jpg"
  end

  def temp_stacked_img_path
    "#{Rails.root}/tmp/pairing_stacked_#{self.id}.jpg"
  end

  # only generate a new image if the the images changed
  def generate_images
    if self.orig_file1_id != self.image_file1_id ||
      self.orig_file2_id != self.image_file2_id

      # create the thumb nail
      # crop left, crop right and then append
      x = Subexec.run "convert  \"#{Rails.root}/public#{self.image_file1.file.url(:thumb, false)}\" \\
            -crop #{self.image_file1.image_width(:thumb).to_i/2}x#{self.image_file1.image_height(:thumb)}+0+0 \\
            +repage  \\
            \"#{Rails.root}/public#{self.image_file2.file.url(:thumb, false)}\" \\
            -crop #{self.image_file2.image_width(:thumb).to_i/2}x#{self.image_file2.image_height(:thumb)}+#{self.image_file2.image_width(:thumb).to_i/2}+0 \\
            +repage \\
            +append #{temp_thumbnail_path}"

      self.thumbnail = File.new(temp_thumbnail_path, 'r') if File.exists?(temp_thumbnail_path)

      # create the stacked image
      x = Subexec.run "convert  \"#{Rails.root}/public#{self.image_file1.file.url(:original, false)}\" \\
            \"#{Rails.root}/public#{self.image_file2.file.url(:original, false)}\" \\
            -append #{temp_stacked_img_path}"

      self.stacked_img = File.new(temp_stacked_img_path, 'r') if File.exists?(temp_stacked_img_path)
    end
  end

  def delete_generated_images
    File.delete(temp_thumbnail_path) if File.exists?(temp_thumbnail_path)
    File.delete(temp_stacked_img_path) if File.exists?(temp_stacked_img_path)
  end

end
