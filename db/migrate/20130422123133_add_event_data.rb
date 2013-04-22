# encoding: UTF-8
class AddEventData < ActiveRecord::Migration
  def up
    l = Location.create(:type_id => Location::TYPES[:event])
    l.location_translations.create(:locale => 'ka', :name => 'საბჭოთა ოკუპაცია 1921-1989')
    l.location_translations.create(:locale => 'en', :name => 'Soviet Occupation 1921-1991')

    l = Location.create(:type_id => Location::TYPES[:event])
    l.location_translations.create(:locale => 'ka', :name => 'სამოქალაქო ომი 1991-1992')
    l.location_translations.create(:locale => 'en', :name => 'Civil War 1991-1992')
  end

  def down
    Location.where(:type_id => Location::TYPES[:event]).destroy_all
  end
end
