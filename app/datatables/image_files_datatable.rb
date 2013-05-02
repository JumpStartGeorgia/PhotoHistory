class ImageFilesDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ImageFile.count,
      iTotalDisplayRecords: image_files.total_entries,
      aaData: data
    }
  end

private

  def data
    return
    image_files.map do |image_file|
      [
        link_to(image_file.name, image_file, :locale => I18n.locale),
        h(image_file.category),
        h(image_file.released_on.strftime("%B %e, %Y")),
        number_to_currency(image_file.price)
      ]
    end
  end

  def image_files
    abort fetch_image_files.inspect
    @image_files ||= fetch_image_files
  end

  def fetch_image_files
    image_files = ImageFile.order("#{sort_column} #{sort_direction}")
    image_files = image_files.page(page).per_page(per_page)
    if params[:sSearch].present?
      image_files = image_files.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
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
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
