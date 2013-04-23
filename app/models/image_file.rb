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
  has_many :image_file_events, :dependent => :destroy
  has_many :events, :through => :image_file_events
  belongs_to :category_district, :class_name => 'Category', :foreign_key => 'district_id'
  belongs_to :category_place, :class_name => 'Category', :foreign_key => 'place_id'

  accepts_nested_attributes_for :image_file_translations
  attr_accessible :file, :image_file_translations_attributes, :file_content_type, :file_file_size, :file_updated_at, :file_file_name, 
    :year, :lat, :lon, 
    #:district, :place, - old
    :file_meta, :source, :district_id, :place_id,
    :add_watermark, :event_ids, :photographer

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

  def self.distinct_district_ids
    select("distinct district_id").where("district_id is not null").map{|x| x.district_id}
  end
  
  def self.distinct_place_ids
    select("distinct place_id").where("place_id is not null").map{|x| x.place_id}
  end
  
  def year_formatted
    self.year.present? ? self.year : I18n.t('app.common.unknown_year')
  end

  def source_formatted
    x = ''
     
    if self.source.present?
      x << self.source
    else
      x << I18n.t('app.common.unknown_source')
    end
    x << " ("
    x << self.year_formatted.to_s
    x << ")"

    return x
  end

  def photographer_formatted
    self.photographer.present? ? self.photographer : I18n.t('app.common.unknown_source')
  end

  def district_name
    category_district.name if self.district_id.present?
  end

  def district_permalink
    category_district.permalink if self.district_id.present?
  end

  def place_name
    category_place.name if self.place_id.present?
  end

  def place_permalink
    category_place.permalink if self.place_id.present?
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
    text = "#{self.source} | #{I18n.t('app.common.app_name', :locale => :ka)}".to_ascii.gsub(/[^0-9A-Za-z|_\- ]/,'').titlecase
    # large
    path = "#{Rails.root}/public#{self.file.url(:large, false)}"
    Subexec.run "convert \"#{path}\" -pointsize 13 -font Sylfaen-Regular -fill \"rgba(255,255,255,0.5)\" -gravity southeast -annotate +10+10 \"#{text}\" #{path}"

    # medium
    path = "#{Rails.root}/public#{self.file.url(:medium, false)}"
    Subexec.run "convert \"#{path}\" -pointsize 11 -font Sylfaen-Regular -fill \"rgba(255,255,255,0.5)\" -gravity southeast -annotate +10+10 \"#{text}\" #{path}"

    # thumb
    path = "#{Rails.root}/public#{self.file.url(:thumb, false)}"
    Subexec.run "convert \"#{path}\" -pointsize 9 -font Sylfaen-Regular -fill \"rgba(255,255,255,0.5)\" -gravity southeast -annotate +10+10 \"#{text}\" #{path}"

  end
end
