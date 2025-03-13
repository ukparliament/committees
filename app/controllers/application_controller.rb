class ApplicationController < ActionController::Base
	rescue_from ActionController::UnknownFormat, with: :unsupported_media_type

  private

  def unsupported_media_type
    render plain: 'Not supported', status: :unsupported_media_type
  end
end
