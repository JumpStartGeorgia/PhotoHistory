# encoding: UTF-8
class CreateLocationRecords < ActiveRecord::Migration
  def up
    #districts
    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'გლდანი')
    l.location_translations.create(:locale => 'en', :name => 'Gldani')
    ImageFile.where(:district => 'Gldani').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'დიდუბე')
    l.location_translations.create(:locale => 'en', :name => 'Didube')
    ImageFile.where(:district => 'Didube').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'ვაკე')
    l.location_translations.create(:locale => 'en', :name => 'Vake')
    ImageFile.where(:district => 'Vake').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'ისანი')
    l.location_translations.create(:locale => 'en', :name => 'Isani')
    ImageFile.where(:district => 'Isani').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'კრწანისი')
    l.location_translations.create(:locale => 'en', :name => 'Krtsanisi')
    ImageFile.where(:district => 'Krtsanisi').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'მთაწმინდა')
    l.location_translations.create(:locale => 'en', :name => 'Mtatsminda')
    ImageFile.where(:district => 'Mtatsminda').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'ნაძალადევი')
    l.location_translations.create(:locale => 'en', :name => 'Nadzaladevi')
    ImageFile.where(:district => 'Nadzaladevi').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'საბურთალო')
    l.location_translations.create(:locale => 'en', :name => 'Saburtalo')
    ImageFile.where(:district => 'Saburtalo').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'სამგორი')
    l.location_translations.create(:locale => 'en', :name => 'Samgori')
    ImageFile.where(:district => 'Samgori').update_all(:district_id => l.id)

    l = Location.create(:type_id => Location::TYPES[:district])
    l.location_translations.create(:locale => 'ka', :name => 'ჩუღურეთი')
    l.location_translations.create(:locale => 'en', :name => 'Chugureti')
    ImageFile.where(:district => 'Chugureti').update_all(:district_id => l.id)

    #special areas
    l = Location.create(:type_id => Location::TYPES[:special])
    l.location_translations.create(:locale => 'ka', :name => 'რუსთაველის გამზირი')
    l.location_translations.create(:locale => 'en', :name => 'Rustaveli Avenue')
    ImageFile.where(:special => 'Rustaveli Avenue').update_all(:special_id => l.id)
  end

  def down
    Location.delete_all
    LocationTranslation.delete_all

    ImageFile.update_all(:district_id => nil, :special_id => nil)
  end
end
