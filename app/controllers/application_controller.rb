class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization

  # Pundit: allow-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :artist, :admin, :profile_picture])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :artist, :admin, :profile_picture])
  end

  def set_language
    puts "Set language action called!" # Add this line
    referer = URI(request.referer || "").path
    locale = referer.ends_with?("/es") ? :en : :es

    if I18n.available_locales.include?(locale)
      session[:locale] = locale
      cookies.permanent[:locale] = { value: locale, expires: 1.year.from_now }
    end

    I18n.locale = locale # Set the current locale immediately

    redirect_back(fallback_location: root_path)
  end

  def set_locale
    I18n.locale = session[:locale] || cookies[:locale] || I18n.default_locale
  end

  skip_after_action :verify_authorized, only: :set_language

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def set_user
    @user = current_user
  end
end
