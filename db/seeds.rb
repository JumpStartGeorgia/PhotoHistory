# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#######################
## add city categories
# see if tbilisi already exists
puts 'adding city categories'
tbilisi = Category.joins(:category_translations).where("category_translations.name = 'Tbilisi' and categories.type_id = ?", Category::TYPES[:city])
tbilisi_id = nil
if tbilisi.present?
  tbilisi_id = tbilisi.first.id
end
Category.where(:type_id => Category::TYPES[:city]).destroy_all
c = Category.create(:type_id => Category::TYPES[:city])
c.category_translations.create(:locale => 'en', :name => 'Tbilisi')
c.category_translations.create(:locale => 'ka', :name => 'თბილისი')
# add tbilisi as parent for all districts
# add tbiliti to image files too
if tbilisi_id.present?
  Category.where(:type_id => Category::TYPES[:district], :ancestry => tbilisi_id).update_all(:ancestry => c.id)
  ImageFile.where(:city_id => tbilisi_id).update_all(:city_id => c.id)
else
  Category.where(:type_id => Category::TYPES[:district]).update_all(:ancestry => c.id)
  ImageFile.where('district_id is not null').update_all(:city_id => c.id)
end
c = Category.create(:type_id => Category::TYPES[:city])
c.category_translations.create(:locale => 'en', :name => 'Gori')
c.category_translations.create(:locale => 'ka', :name => 'გორი')
