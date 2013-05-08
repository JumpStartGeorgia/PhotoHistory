class Admin::PairingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:user])
  end

  # GET /pairings
  # GET /pairings.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: PairingsDatatable.new(view_context, params[:not_published]) }
    end
  end

  # GET /pairings/1
  # GET /pairings/1.json
  def show
    @pairing = Pairing.find(params[:id])

    gon.lat = @pairing.image_file1.lat
    gon.lon = @pairing.image_file1.lon
    gon.load_image_pairing = true

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pairing }
    end
  end

  # GET /pairings/new
  # GET /pairings/new.json
  def new
    @pairing = Pairing.new

    # create the translation object for the locales that were selected
	  # so the form will properly create all of the nested form fields
		I18n.available_locales.each do |locale|
			@pairing.pairing_translations.build(:locale => locale.to_s)
			@pairing.build_image_file1
			@pairing.build_image_file2
		end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pairing }
    end
  end

  # GET /pairings/1/edit
  def edit
    @pairing = Pairing.find(params[:id])
  end

  # POST /pairings
  # POST /pairings.json
  def create
    @pairing = Pairing.new(params[:pairing])

    respond_to do |format|
      if @pairing.save
        format.html { redirect_to admin_pairing_path(@pairing), notice: t('app.msgs.success_created', :obj => t('activerecord.models.pairing')) }
        format.json { render json: @pairing, status: :created, location: @pairing }
      else
        format.html { render action: "new" }
        format.json { render json: @pairing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pairings/1
  # PUT /pairings/1.json
  def update
    @pairing = Pairing.find(params[:id])

    respond_to do |format|
      if @pairing.update_attributes(params[:pairing])
        format.html { redirect_to admin_pairing_path(@pairing), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.pairing')) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pairing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pairings/1
  # DELETE /pairings/1.json
  def destroy
    @pairing = Pairing.find(params[:id])
    @pairing.destroy

    respond_to do |format|
      format.html { redirect_to admin_pairings_url }
      format.json { head :ok }
    end
  end


  # publish the records that have the ids listed in params[:publish_ids]
  def publish
    x = 0
    if params[:publish_ids].present?
      params[:publish_ids].each do |id|
        p = Pairing.find_by_id(id)
        if p.present?
          p.published = true
          if p.save
            x += 1
          end
        end
      end
    end
		flash[:notice] =  t('app.msgs.selected_published', :number => x)
		redirect_to admin_pairings_path
  end
end
