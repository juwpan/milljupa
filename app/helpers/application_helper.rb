module ApplicationHelper
  def fa_icon(icon_class)
    content_tag 'span', '', class: "bi bi-#{icon_class} btn btn-info"
  end
end
