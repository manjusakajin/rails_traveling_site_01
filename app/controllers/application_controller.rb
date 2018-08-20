class ApplicationController < ActionController::Base
  before_action :set_locale

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to request.referrer || root_url
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:danger] = exception.message
    redirect_to request.referrer || root_url
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options _options = {}
    {locale: I18n.locale}
  end
end
