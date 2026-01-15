class HomeController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
    if htmx_request?
      render :index, layout: false
    end
  end
end
