class ApplicationController < ActionController::Base
  before_action :set_locale
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :artist, :admin, :profile_picture, :username])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :artist, :admin, :profile_picture, :username])
  end

  def set_language
    requested = params[:locale].to_s.downcase.to_sym
    target_locale = if [:en, :es].include?(requested)
                      requested
                    elsif I18n.locale == :en
                      :es
                    else
                      :en
                    end

    session[:locale] = target_locale
    cookies.permanent[:locale] = { value: target_locale.to_s, expires: 1.year.from_now }
    I18n.locale = target_locale

    redirect_back(fallback_location: root_path)
  end

  def set_locale
    raw_locale = params[:locale] || session[:locale] || cookies[:locale] || I18n.default_locale
    locale = raw_locale.to_s.downcase.to_sym
    if [:en, :es].include?(locale)
      I18n.locale = locale
      session[:locale] = locale
    else
      I18n.locale = I18n.default_locale
    end
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
