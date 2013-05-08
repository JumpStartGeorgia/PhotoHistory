class ImageFilesDatatable
  include Rails.application.routes.url_helpers
  delegate :params, :h, :link_to, :number_to_currency, :image_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ImageFile.for_datatable.count,
      iTotalDisplayRecords: image_files.total_entries,
      aaData: data
    }
  end

private

  def data
    image_files.map do |image_file|
      [
        link_to(image_file.name, admin_image_file_path(:id => image_file.id, :locale => I18n.locale)),
        image_file.year,
        image_file.source,
        image_file.photographer,
        image_file.district_name,
        image_file.place_name,
        image_file.events.present? ? image_file.events.map{|x| x.name}.join(', ') : nil,
        image_file.file_file_name.present? ? image_tag(image_file.file.url(:thumb)) : nil,
        action_links(image_file)
      ]
    end
  end

  def action_links(image_file)
    x = ""
    x << link_to(I18n.t("helpers.links.edit"),
                    edit_admin_image_file_path(:id => image_file.id, :locale => I18n.locale), :class => 'btn btn-mini')
    x << " "
    x << link_to(I18n.t("helpers.links.destroy"),
                    admin_image_file_path(:id => image_file.id, :locale => I18n.locale),
                    :method => :delete,
								    :data => { :confirm => I18n.t("helpers.links.confirm") },
                    :class => 'btn btn-mini btn-danger')
    x << "<br /><br />"
    x << I18n.t('app.common.added_on', :date => "<br/>#{I18n.l(image_file.created_at, :format => :short)}")
    return x.html_safe
  end

  def image_files
    @image_files ||= fetch_image_files
  end

  def fetch_image_files
    image_files = ImageFile.for_datatable.order("#{sort_column} #{sort_direction}")
    image_files = image_files.page(page).per_page(per_page)
    if params[:sSearch].present?
      search_qry = "image_file_translations.name like :search "  
      search_qry << "or image_files.year like :search "
      search_qry << "or image_files.source like :search "
      search_qry << "or image_file_translations.photographer like :search "
      search_qry << "or category_translations.name like :search "
      search_qry << "or category_translations_categories.name like :search "
      image_files = image_files.where(search_qry, search: "%#{params[:sSearch]}%")
    end
    image_files
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[image_file_translations.name image_files.year image_files.source image_file_translations.photographer category_translations.name category_translations_categories.name image_files.year image_files.year image_files.created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
