class YearRange < ActiveRecord::Base
	translates :title, :permalink

	has_many :year_range_translations, :dependent => :destroy

  accepts_nested_attributes_for :year_range_translations
  attr_accessible :start, :end, :year_range_translations_attributes, :sort

  def self.sorted
    with_translations(I18n.locale).order("year_ranges.sort, year_range_translations.title asc")
  end

  def query_clause
    if self.start.present? && self.end.present?
      "image_files.year between #{self.start} and #{self.end}"
    elsif self.start.present?
      "image_files.year >= #{self.start}"
    elsif self.end.present?
      "image_files.year < #{self.end}"
    end
  end

end
