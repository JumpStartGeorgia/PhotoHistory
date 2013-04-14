module ImageFilesHelper
  def district_collection
    x = []
    t(:'filters.location.districts.list').each_line do |item| 
      x << item.chomp! 
    end                   
    return x    
  end

  def special_collection
    x = []
    t(:'filters.location.special.list').each_line do |item| 
      x << item.chomp! 
    end                   
    return x    
  end
end
