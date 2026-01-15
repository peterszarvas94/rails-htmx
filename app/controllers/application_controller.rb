class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate etag for HTML responses
  stale_when_importmap_changes

  # HTMX detection helper
  def htmx_request?
    request.headers["HX-Request"].present?
  end
  helper_method :htmx_request?

  # HTMX CSRF headers helper
  def htmx_csrf_headers
    { "X-CSRF-Token": form_authenticity_token }.to_json
  end
  helper_method :htmx_csrf_headers
end
