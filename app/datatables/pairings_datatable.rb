class PairingsDatatable
  include Rails.application.routes.url_helpers
  delegate :params, :h, :link_to, :number_to_currency, :image_tag, to: :@view
  delegate :not_published, to: :@not_published

  def initialize(view, not_published)
    @view = view
    @not_published = not_published == "true" ? true : false
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: data_query.with_images.count,
      iTotalDisplayRecords: pairings.total_entries,
      aaData: data
    }
  end

private

  def data
    pairings.map do |pairing|
      [
        link_to(pairing.title, admin_pairing_path(:id => pairing.id, :locale => I18n.locale)),
        create_image(pairing.image_file1),
        create_image(pairing.image_file2),
        is_published(pairing),
        action_links(pairing)
      ]
    end
  end

  def data_query
    if @not_published
      Pairing.unpublished
    else
      Pairing
    end
  end

  def create_image(image_obj)
    x = ""
    if image_obj.present?
      x << image_obj.year.to_s
      x << "<br />"
      x << image_tag(image_obj.file.url(:thumb)) if image_obj.file_file_name
    end
    return x.html_safe
  end

  def is_published(pairing)
    x = ""
    if pairing.published?
      x << "<div class=\"published\">"
      x << I18n.t('app.common.published_on', :date => I18n.l(pairing.published_date, :format => :short))
      x << "</div>"
    else
      x << "<div class=\"not_published\">"
      x << I18n.t('app.common.not_published')
      x << "</div>"
      x << "<div>"
      x << "<label>"
      x << "<input type=\"checkbox\" name=\"publish_ids[]\" value=\"#{pairing.id}\" \> "
      x << I18n.t('app.common.publish')
      x << "</label>"
      x << "</div>"
    end
    return x.html_safe
  end

  def action_links(pairing)
    x = ""
    x << link_to(I18n.t("helpers.links.edit"),
                    edit_admin_pairing_path(:id => pairing.id, :locale => I18n.locale), :class => 'btn btn-mini')
    x << " "
    x << link_to(I18n.t("helpers.links.destroy"),
                    admin_pairing_path(:id => pairing.id, :locale => I18n.locale),
                    :method => :delete,
								    :data => { :confirm => I18n.t("helpers.links.confirm") },
                    :class => 'btn btn-mini btn-danger')
    x << "<br /><br />"
    x << I18n.t('app.common.added_on', :date => "<br/>#{I18n.l(pairing.created_at, :format => :short)}")
    return x.html_safe
  end

  def pairings
    @pairings ||= fetch_pairings
  end

  def fetch_pairings
    pairings = data_query.with_images.order("#{sort_column} #{sort_direction}")
    pairings = pairings.page(page).per_page(per_page)
    if params[:sSearch].present?
      search_qry = "pairing_translations.title like :search "  
      pairings = pairings.where(search_qry, search: "%#{params[:sSearch]}%")
    end
    pairings
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[pairing_translations.title image_files.year image_files2.year pairings.published pairings.created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
