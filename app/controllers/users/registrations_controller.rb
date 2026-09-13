class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def configure_permitted_parameters
    added_attrs = [ :name, :phone ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
