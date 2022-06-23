module UserHelper
  def resources_name
    :user
  end

  def resources
    @resources ||= User.new
  end

  def resources_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mapping[:user]
  end

  def flash_class(level)
    case level
        when :notice then "alert alert-success"
        when :error then "alert alert-danger"
        when :alert then "alert alert-danger"
    end
  end
end
