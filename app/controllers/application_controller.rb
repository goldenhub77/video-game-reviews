class ApplicationController < ActionController::Base
  include AdminsHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:home]
  before_action :authorize_owner!, only: [:edit, :create, :destroy]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authorize_admin!, if: :admins_controller?

  def authorize_owner!
    unless controller_path == 'devise/registrations' or controller_path == 'devise/sessions'
      begin
        if params[:id].nil?
          return nil
        else
          resource = current_user.send(controller_path).find(params[:id])
          if !current_user.is_admin? and resource.user != current_user
            redirect_back(fallback_location: "#{controller_path}#index")
            return false
          else
            return true
          end
        end
      rescue NoMethodError => message
        puts message
        return false
      end
    end
  end

  def authorize_admin!
    if current_user.nil? or !current_user.admin?
      flash[:notice] =  "You are not authorized to view this resource."
      redirect_back(fallback_location: root_path)
    end
  end

  def no_results!(term)
    flash[:notice] = "There are no results matching the term '#{term}'"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
