class RootController < ApplicationController

  def index
    @pairing = Pairing.with_images
    if params[:pairing].present?
      @pairing = @pairing.find(params[:pairing])
    else
      @pairing = @pairing.first
    end

    gon.lat = @pairing.image_file1.lat if @pairing.image_file1.lat.present?
    gon.lon = @pairing.image_file1.lon if @pairing.image_file1.lon.present?

    pairings = Pairing.select("pairings.id")
    @pairing_count = pairings.count
    @pairing_index = pairings.index{|x| x.id == @pairing.id} + 1
  end

  def next
    next_previous('next')
  end

  def previous
    next_previous('previous')
  end


protected
  def next_previous(type)
		# get a list of pairings ids in correct order
    pairings = Pairing.select("pairings.id")
    
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
        redirect_to root_path(:pairing => record_id)
        return
      end
    end

		# if get here, then next record was not found
    redirect_to(root_path, :alert => t("app.common.page_not_found"))
    return
  end

end
