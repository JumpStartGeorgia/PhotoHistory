class ImageFile < ActiveRecord::Base
	translates :name, :description, :photographer, :source

  geocoded_by :address, :latitude  => :lat, :longitude => :lon
  reverse_geocoded_by :lat, :lon
  def address
    [place, district].compact.join(', ')
  end
  
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
  belongs_to :category_city, :class_name => 'Category', :foreign_key => 'city_id'

  has_many :pairing1s, :class_name => 'Pairing', :foreign_key => 'image_file1_id'
  has_many :pairing2s, :class_name => 'Pairing', :foreign_key => 'image_file1_id'

  accepts_nested_attributes_for :image_file_translations
  attr_accessible :file, :image_file_translations_attributes, :file_content_type, :file_file_size, :file_updated_at, :file_file_name, 
    :year, :lat, :lon, 
    #:district, :place, :source, - old
    :file_meta, :district_id, :place_id, :city_id,
    :add_watermark, :event_ids, :photographer_old

	attr_accessor :images_processed, :new_source, :orig_add_watermark

  validates :file_file_name, :presence => true
  validates :file_file_name, :length => {:maximum => 120}

  after_find :save_orig_values
  after_post_process :reprocess_images
  after_save :update_watermarks
  after_commit :update_images

  def self.for_datatable
    includes(:category_district => :category_translations, :category_place => :category_translations, :category_city => :category_translations)
    .with_translations(I18n.locale)
  end

	def self.sorted
		with_translations(I18n.locale).order("image_file_translations.name asc, image_files.year asc")
	end

  def self.recent
    with_translations(I18n.locale).order("image_files.created_at desc, image_file_translations.name asc, image_files.year asc")
  end

  def self.distinct_city_ids
    joins(:pairing1s).select("distinct image_files.city_id").where("image_files.city_id is not null and pairings.published = 1").map{|x| x.city_id}
  end
  
  def self.distinct_district_ids
    joins(:pairing1s).select("distinct image_files.city_id, image_files.district_id").where("image_files.district_id is not null and pairings.published = 1").map{|x| [x.city_id, x.district_id]}
  end
  
  def self.distinct_place_ids
    joins(:pairing1s).select("distinct image_files.place_id").where("image_files.place_id is not null and pairings.published = 1").map{|x| x.place_id}
  end
  
  def year_formatted
    self.year.present? ? self.year : I18n.t('app.common.unknown_year')
  end

  def source_formatted
    self.source.present? ? self.source : I18n.t('app.common.unknown_source')
  end

  def photographer_formatted
    self.photographer.present? ? self.photographer : I18n.t('app.common.unknown_source')
  end

  def city_name
    category_city.name if self.city_id.present?
  end

  def city_permalink
    category_city.permalink if self.city_id.present?
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
    #self.orig_source = self.source # if self.has_attribute?(:source)
    self.orig_add_watermark = self.add_watermark if self.has_attribute?(:add_watermark)
  end

  # if an image was added/changed, add the watermark and reprocess the pairing images
  def reprocess_images
    self.images_processed = true    
  end

  # if source changed, reprocess the image
  # if watermark value chagned, reprocess image
  def update_watermarks
    logger.debug "$$$$$$$$$$$$$$$$$ update watermarks"
    logger.debug "@@@@@@@@@@@ new source = #{self.new_source}; orig add = #{self.orig_add_watermark}; add = #{self.add_watermark}"
    if self.new_source || self.orig_add_watermark != self.add_watermark
      logger.debug "@@@@@@@@@@@@@@@@@@@@@@ REPROCESS!"
      self.new_source = false
      self.orig_add_watermark = self.add_watermark
      self.file.reprocess!
    end
  end


  def update_images
    logger.debug "!!!!!!!!!!!1 update images"
    if images_processed
      logger.debug "!!!!!!!!!!!1 image processed!"
      logger.debug "!!!!!!!!!!!1 add = #{self.add_watermark}; source = #{self.translation_for(:en).source}"
      # add watermark to the 3 sizes if wanted
      if self.add_watermark && self.translation_for(:en).source.present?
        logger.debug "!!!!!!!!!!!1 making watermarks!"
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
  # always do watermarks in english
  def generate_watermarks
    text = "#{self.translation_for(:en).source} | #{I18n.t('app.common.app_name', :locale => :en)}".to_ascii.gsub(/[^0-9A-Za-z|_\- ]/,'')
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
