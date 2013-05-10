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
		@pairing.build_image_file1
		@pairing.build_image_file2
		I18n.available_locales.each do |locale|
			@pairing.pairing_translations.build(:locale => locale.to_s)
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

  def full_form
    @pairing = Pairing.new
    @image_file1 = ImageFile.new
    @image_file2 = ImageFile.new

Rails.logger.debug "***** post = #{request.post?}; put = #{request.put?}; get = #{request.get?}"
		if request.put?
Rails.logger.debug "***** request is put"
      Pairing.transaction do

        @pairing = Pairing.new(params[:pairing])
        @image_file1 = ImageFile.new(params[:image_file1])
        @image_file2 = ImageFile.new(params[:image_file2])
  Rails.logger.debug "***** @pairing = #{@pairing.inspect}"
  Rails.logger.debug "***** @imagefile 1 = #{@image_file1.inspect}"
  Rails.logger.debug "***** @imagefile 2 = #{@image_file2.inspect}"

        # assuming all objects were created from form

        # add name/title from pairing to image 1/2
  Rails.logger.debug "***** add trans data"
		    I18n.available_locales.each do |locale|
          pairing_trans = @pairing.pairing_translations.select{|x| x.locale == locale.to_s}.first
          img1_trans = @image_file1.image_file_translations.select{|x| x.locale == locale.to_s}.first
          img2_trans = @image_file2.image_file_translations.select{|x| x.locale == locale.to_s}.first

          img1_trans.name = pairing_trans.title
          img1_trans.description = pairing_trans.description
          img2_trans.name = pairing_trans.title
        end

        # add categories from image 1 to image 2
        # - event only applies to image 1 so ignore
  Rails.logger.debug "***** adding img 1 data to img 2"
        @image_file2.lat = @image_file1.lat
        @image_file2.lon = @image_file1.lon
        @image_file2.district_id = @image_file1.district_id
        @image_file2.place_id = @image_file1.place_id

        valid_images = false
  Rails.logger.debug "***** trying to save img 1 and img 2"
        if @image_file1.save && @image_file2.save
  Rails.logger.debug "***** saved img 1 and img 2"

          @pairing.image_file1_id = @image_file1.id
          @pairing.image_file2_id = @image_file2.id

          valid_images = true
        else
  Rails.logger.debug "***** error saving img 1 or img 2"
        end

        respond_to do |format|
          if valid_images && @pairing.save
  Rails.logger.debug "***** saved pairing"
            format.html { redirect_to admin_pairing_path(@pairing), notice: t('app.msgs.success_created', :obj => t('activerecord.models.pairing')) }
            format.json { render json: @pairing, status: :created, location: @pairing }
          else
  Rails.logger.debug "***** img file 1 errors: #{@image_file1.errors.full_messages}"
  Rails.logger.debug "***** img file 2 errors: #{@image_file1.errors.full_messages}"
  Rails.logger.debug "***** pairing errors: #{@pairing.errors.full_messages}"
            @error_count = @image_file1.errors.count + @image_file2.errors.count + @pairing.errors.count
            gon.edit_image_file = true
            format.html { render }
            format.json { render json: @pairing.errors, status: :unprocessable_entity }
            raise ActiveRecord::Rollback
          end
        end
      end      

    else
      # create the translation object for the locales that were selected
	    # so the form will properly create all of the nested form fields
      @image_file1.lat = gon.edit_lat
      @image_file1.lon = gon.edit_lon
		  I18n.available_locales.each do |locale|
			  @pairing.pairing_translations.build(:locale => locale.to_s)
        @image_file1.image_file_translations.build(:locale => locale.to_s)
        @image_file2.image_file_translations.build(:locale => locale.to_s)
		  end

      gon.edit_image_file = true

      respond_to do |format|
        format.html # full_form.html.erb
        format.json { render json: @pairing }
      end
    end
  end

end
