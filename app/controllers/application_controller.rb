class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

    # Si usas parámetros extras en Devise, aquí va configure_permitted_parameters
  include Devise::Controllers::Helpers

  protected

  def after_sign_in_path_for(resource)
    new_documento_path  # ⬅️ aquí va la ruta a donde quieres redirigir
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_user_session_path   # ⬅️ cámbialo a donde quieras
  end
end
