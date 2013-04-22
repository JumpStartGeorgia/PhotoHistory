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
  belongs_to :location_place, :class_name => 'Location', :foreign_key => 'place_id'

  accepts_nested_attributes_for :image_file_translations
  attr_accessible :file, :image_file_translations_attributes, :file_content_type, :file_file_size, :file_updated_at, :file_file_name, 
    :year, :lat, :lon, 
    #:district, :place, - old
    :file_meta, :source, :district_id, :place_id,
    :add_watermark

	attr_accessor :images_processed, :orig_source, :orig_add_watermark


  validates :file_file_name, :presence => true
  validates :file_file_name, :length => {:maximum => 120}

  after_find :save_orig_values
  after_post_process :reprocess_images
  after_save :update_watermarks
  after_commit :update_images

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

  def place_name
    location_place.name if self.place_id.present?
  end

  def place_permalink
    location_place.permalink if self.place_id.present?
  end

  # pull out the image width from the image_size value
  def image_width(style)
    x = self.file.image_size(style).split('x').first if self.file_meta.present?
    # if for some reason image size does not exist, return a default value
    if x.nil?
      if style == :medium
        x = 653
      elsif style == :thumb
        x = 327
      else
        x = 980
      end
    end

    return x
  end

  # pull out the image width from the image_size value
  def image_height(style)
    x = self.file.image_size(style).split('x')[1] if self.file_meta.present?
    # if for some reason image size does not exist, return a default value
    if x.nil?
      if style == :medium
        x = 467
      elsif style == :thumb
        x = 233
      else
        x = 700
      end
    end

    return x
  end

  protected

  # save the original value of the source and add watermark
  def save_orig_values
    self.orig_source = self.source if self.has_attribute?(:source)
    self.orig_add_watermark = self.add_watermark if self.has_attribute?(:add_watermark)
  end

  # if an image was added/changed, add the watermark and reprocess the pairing images
  def reprocess_images
    self.images_processed = true    
  end

  # if source changed, reprocess the image
  # if watermark value chagned, reprocess image
  def update_watermarks
    if self.orig_source != self.source || self.orig_add_watermark != self.add_watermark
      self.orig_source = self.source
      self.orig_add_watermark = self.add_watermark
      self.file.reprocess!
    end
  end


  def update_images
    if images_processed
      # add watermark to the 3 sizes if wanted
      if self.add_watermark && self.source.present?
        generate_watermarks
      end

      # update any pairing images this belongs to
      pairings = Pairing.where("image_file1_id = :id or image_file2_id = :id", :id => self.id)
      if pairings.present?
        pairings.each do |p|
          p.recreate_image
        end
      end
    end
  end

  # add watermark to the 3 sizes 
  # - do not modify original
  def generate_watermarks
    # large
    path = "#{Rails.root}/public#{self.file.url(:large, false)}"
    Subexec.run "convert \"#{path}\" -pointsize 14 -font Arial-Regular -fill \"rgba(255,255,255,0.5)\" -gravity southeast -annotate +5+0 \"#{self.source}\" #{path}"

    # medium
    path = "#{Rails.root}/public#{self.file.url(:medium, false)}"
    Subexec.run "convert \"#{path}\" -pointsize 12 -font Arial-Regular -fill \"rgba(255,255,255,0.5)\" -gravity southeast -annotate +5+0 \"#{self.source}\" #{path}"

    # thumb
    path = "#{Rails.root}/public#{self.file.url(:thumb, false)}"
    Subexec.run "convert \"#{path}\" -pointsize 10 -font Arial-Regular -fill \"rgba(255,255,255,0.5)\" -gravity southeast -annotate +5+0 \"#{self.source}\" #{path}"

  end
end
