# encoding: UTF-8
class CreateYearRangeData < ActiveRecord::Migration
  def up
    y = YearRange.create(:start => nil, :end => 1900, :sort => 1)
    y.year_range_translations.create(:locale => 'ka', :title => '1900-მდე')
    y.year_range_translations.create(:locale => 'en', :title => 'Before 1900')

    y = YearRange.create(:start => 1900, :end => 1950, :sort => 2)
    y.year_range_translations.create(:locale => 'ka', :title => '1900-1950')
    y.year_range_translations.create(:locale => 'en', :title => '1900-1950')

    y = YearRange.create(:start => 1950, :end => 2000, :sort => 3)
    y.year_range_translations.create(:locale => 'ka', :title => '1950-2000')
    y.year_range_translations.create(:locale => 'en', :title => '1950-2000')

    y = YearRange.create(:start => 2000, :end => nil, :sort => 4)
    y.year_range_translations.create(:locale => 'ka', :title => '2000-დღემდე')
    y.year_range_translations.create(:locale => 'en', :title => '2000-Present')
  end

  def down
    YearRange.delete_all
    YearRangeTranslation.delete_all
  end
end
