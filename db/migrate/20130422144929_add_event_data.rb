# encoding: UTF-8
class AddEventData < ActiveRecord::Migration
  def up
    l = Category.create(:type_id => Category::TYPES[:event])
    l.category_translations.create(:locale => 'ka', :name => 'საბჭოთა ოკუპაცია 1921-1989')
    l.category_translations.create(:locale => 'en', :name => 'Soviet Occupation 1921-1991')

    l = Category.create(:type_id => Category::TYPES[:event])
    l.category_translations.create(:locale => 'ka', :name => 'სამოქალაქო ომი 1991-1992')
    l.category_translations.create(:locale => 'en', :name => 'Civil War 1991-1992')
  end

  def down
    Category.where(:type_id => Category::TYPES[:event]).destroy_all
  end
end
