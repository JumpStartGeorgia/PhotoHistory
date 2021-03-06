class RootController < ApplicationController

  def index
    @pairing = build_pairing_query
    if params[:pairing].present?
      @pairing = @pairing.find_by_id(params[:pairing])
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

      gon.load_image_pairing = true

		  respond_to do |format|
		    format.html # index.html.erb
		    format.json { render json: @pairing }
		  end

      # update the view count
      impressionist(@pairing)
		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path
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
      pairings = Pairing.published.select("pairings.id").sorted
    else
      pairings = Pairing.published.with_images.sorted
    end

    # add city
    if params[:city].present? && params[:city] != I18n.t('filters.location.all', :locale => :en)

      index = @cities.map{|x| x.permalink}.index(params[:city])
      pairings = pairings.where("image_files.city_id = ?", @cities[index].id) if index
    end

    # add district
    if params[:district].present? && params[:district] != I18n.t('filters.location.all', :locale => :en)

      index = @districts.map{|x| x.permalink}.index(params[:district])
      pairings = pairings.where("image_files.district_id = ?", @districts[index].id) if index
    end

    # add place
    if params[:place].present? && params[:place] != I18n.t('filters.location.all', :locale => :en)

      index = @places.map{|x| x.permalink}.index(params[:place])
      pairings = pairings.where("image_files.place_id = ?", @places[index].id) if index
    end

    # add year
    if params[:year].present?
      if params[:year] == I18n.t('filters.time.unknown', :locale => :en)
        pairings = pairings.where("image_files.year is null or image_files.year = ''")
      elsif params[:year] != I18n.t('filters.time.all', :locale => :en)
        index = @years.map{|x| x.permalink}.index(params[:year])
        pairings = pairings.where(@years[index].query_clause) if index
      end
    end

    # add event
    if params[:event].present?
      index = @events.map{|x| x.permalink}.index(params[:event])
      pairings = pairings.includes(:image_file1 => :image_file_events).where("image_file_events.event_id = ?", @events[index].id) if index
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
    pairing = Pairing.published.find_by_id(params[:id])
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
