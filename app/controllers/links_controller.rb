class LinksController < ApplicationController
  before_action :set_link, only: %i[show create]

  def top
    @links = Link.top_links(100)

    json_response(@links.to_json(only: %i[title long_link short_link]))
  end

  def show
    respond_to do |format|
      if @link.present?
        @link.create_visit!
        format.json { json_response(@link.to_json(only: %i[long_link short_link])) }
        format.html { redirect_to @link.http_link }
      else
        format.json { render json: { errors: 'Invalid URL' } }
        format.html { render file: 'public/404', layout: false, status: :not_found }
      end
    end
  end

  def create
    link = Link.find_or_initialize_by(link_params)

    respond_to do |format|
      if Link.exists?(link.id) || link.save
        format.json { json_response(link.to_json(only: %i[long_link short_link])) }
      else
        format.json { render json: { errors: link.errors.full_messages } }
      end
    end
  end

  private

  def set_link
    @link = Link.find_by(short_link: params[:id])
  end

  def link_params
    params.require(:link).permit(:long_link)
  end
end
