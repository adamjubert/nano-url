class LinksController < ApplicationController
  before_action :set_link

  def top
    count_visits_sql = Arel.sql('count(visits.id) desc')

    @links = Link.joins(:visits)
                 .group('links.id')
                 .order(count_visits_sql)
                 .limit(100)

    json_response(@links)
  end

  def show
    respond_to do |format|
      if @link.present?
        @link.create_visit!
        format.json { json_response(@link) }
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
