module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title.html_safe }
  end

  def page_title_only(page_title)
    content_for(:page_title_only) { page_title.html_safe }
  end

  def get_page_title
    x = ''
    if content_for?(:page_title_only)
      x << content_for(:page_title_only)
    elsif content_for?(:title)
      x << content_for(:title)
    end

    # add years if exist
    if @title_year1 && @title_year2
      x << " ("
      x << @title_year1.to_s
      x << " - "
      x << @title_year2.to_s
      x << ")"
    end

    return x.html_safe
  end

	def flash_translation(level)
    case level
    when :notice then "alert-info"
    when :success then "alert-success"
    when :error then "alert-error"
    when :alert then "alert-error"
    end
  end

	# from http://www.kensodev.com/2012/03/06/better-simple_format-for-rails-3-x-projects/
	# same as simple_format except it does not wrap all text in p tags
	def simple_format_no_tags(text, html_options = {}, options = {})
		text = '' if text.nil?
		text = smart_truncate(text, options[:truncate]) if options[:truncate].present?
		text = sanitize(text) unless options[:sanitize] == false
		text = text.to_str
		text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
#		text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
		text.html_safe
	end

  # options = [{key => value, key => value, etc}]
  def update_params(options)
    p = @param_options.clone
    options.each do |option|
      if !option[0].blank?
        p[option[0].to_s] = option[1]
      end
    end
    return p 
  end

  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
	end

  def current_url_no_querystring
		x = nil
    uri = URI("#{request.protocol}#{request.host_with_port}#{request.fullpath}")
    port = uri.port.present? && [80,443].index(uri.port).nil? ? ":#{uri.port}" : ""
		url = "#{uri.scheme}://#{uri.host}#{port}#{uri.path}" 
    # if pairing id in query string, include it in the url
    url << "?pairing=#{params[:pairing]}" if params[:pairing].present?
    return url
	end

	def full_url(path)
		"#{request.protocol}#{request.host_with_port}#{path}"
	end

	# since the url contains english or georgian text, the text must be updated to the correct language
	# for the language switcher link to work
  # - applies to district, place, event, year
	def generate_language_switcher_link(locale)
    distrct = nil
    place = nil
    year = nil
    event = nil

    if params[:district].present?
      index = @districts.map{|x| x.permalink}.index(params[:district])
      if index
        x = CategoryTranslation.where(:locale => locale, :category_id => @districts[index].id)
        if x.present?
          district = x.first.permalink
        end
      end
    end

    if params[:place].present?
      index = @places.map{|x| x.permalink}.index(params[:place])
      if index
        x = CategoryTranslation.where(:locale => locale, :category_id => @places[index].id)
        if x.present?
          place = x.first.permalink
        end
      end
    end

    if params[:year].present? && params[:year] != I18n.t('filters.time.unknown', :locale => :en)
      index = @years.map{|x| x.permalink}.index(params[:year])
      if index
        x = YearRangeTranslation.where(:locale => locale, :year_range_id => @years[index].id)
        if x.present?
          year = x.first.permalink
        end
      end
    end

    if params[:event].present?
      index = @events.map{|x| x.permalink}.index(params[:event])
      if index
        x = CategoryTranslation.where(:locale => locale, :category_id => @events[index].id)
        if x.present?
          event = x.first.permalink
        end
      end
    end


	  link_to t("app.language.#{locale}"), params.merge(:locale => locale, :event => event, :year => year, :district => district, :place => place)

	end

	# Based on https://gist.github.com/1182136
  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end

  def page_navigation_links(pages)
    will_paginate(pages, :class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
  end

end
