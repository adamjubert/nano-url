class LinksController < ApplicationController
  before_action :set_link
  
  def show
    respond_to do |format|
      if @link.present?
        format.json { render :show, status: :ok, location: @link }
        format.html { redirect_to @link.http_link }
      else
        format.json { render json: { errors: 'Invalid URL' } }
      end
    end
  end

  private

  def set_link
    @link = Link.find_by(short_link: params[:id])
  end
end
