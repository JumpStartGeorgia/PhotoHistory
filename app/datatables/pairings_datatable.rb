class PairingsDatatable
  include Rails.application.routes.url_helpers
  delegate :params, :h, :link_to, :number_to_currency, :image_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Pairing.with_images.count,
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
        action_links(pairing)
      ]
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
    x << I18n.l(pairing.updated_at, :format => :short)
    return x.html_safe
  end

  def pairings
    @pairings ||= fetch_pairings
  end

  def fetch_pairings
    pairings = Pairing.with_images.order("#{sort_column} #{sort_direction}")
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
    columns = %w[pairing_translations.title image_files.year image_files2.year pairings.updated_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
