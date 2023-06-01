class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render file: 'public/404.html', status: 404
  end
end
