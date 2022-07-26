# frozen_string_literal: true

module ApplicationHelper
  def fa_icon(icon_class)
    content_tag 'span', '', class: "bi bi-#{icon_class} user-prize"
  end
end
