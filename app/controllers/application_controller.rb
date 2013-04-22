class ApplicationController < ActionController::Base
#	require 'will_paginate/array'
  protect_from_forgery

	before_filter :set_locale
#	before_filter :is_browser_supported?
	before_filter :initialize_gon
  before_filter :create_querystring_hash
	before_filter :preload_global_variables

	unless Rails.application.config.consider_all_requests_local
		rescue_from Exception,
		            :with => :render_error
		rescue_from ActiveRecord::RecordNotFound,
		            :with => :render_not_found
		rescue_from ActionController::RoutingError,
		            :with => :render_not_found
		rescue_from ActionController::UnknownController,
		            :with => :render_not_found
		rescue_from ActionController::UnknownAction,
		            :with => :render_not_found

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end
	end

	Browser = Struct.new(:browser, :version)
	SUPPORTED_BROWSERS = [
		Browser.new("Chrome", "15.0"),
		Browser.new("Safari", "4.0.2"),
		Browser.new("Firefox", "10.0.2"),
		Browser.new("Internet Explorer", "9.0"),
		Browser.new("Opera", "11.0")
	]

	def is_browser_supported?
		user_agent = UserAgent.parse(request.user_agent)
logger.debug "////////////////////////// BROWSER = #{user_agent}"
		if SUPPORTED_BROWSERS.any? { |browser| user_agent < browser }
			# browser not supported
logger.debug "////////////////////////// BROWSER NOT SUPPORTED"
			render "layouts/unsupported_browser", :layout => false
		end
	end


	def set_locale
    if params[:locale] and I18n.available_locales.include?(params[:locale].to_sym)
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
	end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

	def initialize_gon
		gon.set = true
		gon.highlight_first_form_field = true
    # we are using free mapbox account with limited views so don't use them up in dev mode
    if Rails.env.development?
      gon.tile_url = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
    else
      gon.tile_url = "http://a.tiles.mapbox.com/v3/jsgeorgia.map-e254jl56/{z}/{x}/{y}.png"
    end
    gon.map_id = 'map'
    gon.zoom = 17
    gon.max_zoom = 18
    gon.edit_tile_url = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
    gon.edit_map_id = 'map_get_latlon'
    gon.edit_lat = 41.693312056765386
		gon.edit_lon = 44.80155944824219
    gon.edit_zoom = 12

		gon.fb_app_id = ENV['PHOTO_HISTORY_FACEBOOK_APP_ID']
	end

  def preload_global_variables
    @districts = Category.by_type(Category::TYPES[:district])
    @places = Category.by_type(Category::TYPES[:place])
    @events = Category.by_type(Category::TYPES[:event])
    @years = YearRange.sorted

    @image_districts = ImageFile.distinct_district_ids
    @image_places = ImageFile.distinct_place_ids
    @image_events = ImageFileEvent.distinct_event_ids

		@fb_app_id = ENV['PHOTO_HISTORY_FACEBOOK_APP_ID']
  end

	# after user logs in, go to admin page
	def after_sign_in_path_for(resource)
		root_path
	end

  def valid_role?(role)
    redirect_to root_path, :notice => t('app.msgs.not_authorized') if !current_user || !current_user.role?(role)
  end

  def create_querystring_hash
    @param_options = Hash.new
    url = URI.parse(request.fullpath)
    @param_options = CGI.parse(url.query).inject({}) { |h, (k, v)| h[k] = v.first; h } if url.query

    # if pairing in params, remove it
    @param_options.delete('pairing')
  end

  #######################
	def render_not_found(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/404.html", :status => 404
	end

	def render_error(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/500.html", :status => 500
	end

end
