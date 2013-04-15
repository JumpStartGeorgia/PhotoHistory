class RootController < ApplicationController

  def index
    @pairing = build_pairing_query
    if params[:pairing].present?
      @pairing = @pairing.find(params[:pairing])
    else
      @pairing = @pairing.first
    end

    if @pairing.present?
      gon.lat = @pairing.image_file1.lat if @pairing.image_file1.lat.present?
      gon.lon = @pairing.image_file1.lon if @pairing.image_file1.lon.present?
      gon.map_marker_text = @pairing.title.titlecase

      pairings = build_pairing_query(true)
      @pairing_count = pairings.count
      @pairing_index = pairings.index{|x| x.id == @pairing.id} + 1
    end
  end

  def about
    render :layout => 'fancybox' if params[:fb].present?
  end 

  def next
    next_previous('next')
  end

  def previous
    next_previous('previous')
  end


protected

  def build_pairing_query(ids_only=false)
    if ids_only
      pairings = Pairing.select("pairings.id").sorted
    else
      pairings = Pairing.with_images.sorted
    end

    # add district
    if params[:district].present? && params[:district] != I18n.t('filters.location.all') &&
        I18n.t(:'filters.location.districts.list').index(params[:district])

        pairings = pairings.where("image_files.district = ?", params[:district])
    end

    # add special area
    if params[:special].present? && params[:special] != I18n.t('filters.location.all') &&
        I18n.t(:'filters.location.special.list').index(params[:special])

        pairings = pairings.where("image_files.special = ?", params[:special])
    end

    # add time
    if params[:time].present?
      if params[:time] == I18n.t('filters.time.unknown')
        pairings = pairings.where("image_files.year is null or image_files.year = ''")
      elsif params[:time] != I18n.t('filters.time.all')
        # format should be yyyy-yyyy
        years = params[:time].split('-')
        if years.length == 2 && years[0].length == 4 && years[1].length == 4 && is_i?(years[0]) && is_i?(years[1])
          pairings = pairings.where("image_files.year between ? and ?", years[0], years[1])
        end
      end
    end

    return pairings
  end

  def is_i?(string)
   !!(string =~ /^[-+]?[0-9]+$/)
  end

  def next_previous(type)
		# get a list of pairings ids in correct order
    pairings = build_pairing_query(true)
    
    # get the pairing that was showing
    pairing = Pairing.find_by_id(params[:id])
		record_id = nil

		if pairings.present? && pairing.present?
			index = pairings.index{|x| x.id == pairing.id}
      if type == 'next'
  			if index
  				if index == pairings.length-1
  					record_id = pairings[0].id
  				else
  					record_id = pairings[index+1].id
  				end
  			else
  				record_id = pairings[0].id
  			end
  		elsif type == 'previous'
				if index
					if index == 0
						record_id = pairings[pairings.length-1].id
					else
						record_id = pairings[index-1].id
					end
				else
					record_id = pairings[0].id
				end
			end

			if record_id 
			  # found next record, go to it
        @param_options[:pairing] = record_id
        redirect_to root_path(@param_options)
        return
      end
    end

		# if get here, then next record was not found
    redirect_to(root_path, :alert => t("app.common.page_not_found"))
    return
  end

end
