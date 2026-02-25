class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit the `name` parameter along with the other default Devise parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :nickname, :phone_number, :birth_date, :gender, :region, :age_group, :address_zipcode, :address_basic, :address_detail, :preferred_size, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :nickname, :phone_number, :birth_date, :gender, :region, :age_group, :address_zipcode, :address_basic, :address_detail, :preferred_size, :avatar])
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    onboarding_path
  end
end
