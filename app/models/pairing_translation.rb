class PairingTranslation < ActiveRecord::Base
	require 'utf8_converter'
  has_permalink :create_permalink

	belongs_to :pairing

  attr_accessible :pairing_id, :title, :description, :permalink, :locale

  validates :title, :permalink, :presence => true
	validates :permalink, :uniqueness => {:scope => :locale, :case_sensitive => false,
			:message => I18n.t('activerecord.errors.messages.already_exists')}


  def create_permalink
    Utf8Converter.convert_ka_to_en(self.title) if self.title
  end


end
