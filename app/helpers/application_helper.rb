module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    
    # Determinamos la dirección (si ya está en asc, el próximo clic será desc)
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    
    # Dibujamos el icono visual
    icon = " ⇕" # Icono neutro por defecto
    if column == params[:sort]
      icon = direction == "asc" ? " ▼" : " ▲"
    end
    
    # Combinamos los filtros actuales de búsqueda con el nuevo orden
    link_params = request.query_parameters.merge(sort: column, direction: direction)
    
    # Generamos el enlace
    link_to "#{title}#{icon}".html_safe, link_params, style: "color: #b0c1d4; text-decoration: none; font-size: 11px; text-transform: uppercase; font-weight: 600;"
  end
end
