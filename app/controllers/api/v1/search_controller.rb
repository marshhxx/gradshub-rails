class Api::V1::SearchController < ApplicationController
  RESULTS_PER_PAGE = 50

  # supported key words: interests, skills, job_titles
  def show
    @users = paginate User.search(query_params[:q]), per_page: per_page
    render :show, status: :ok
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:q, :per_page)
  end

  def per_page
    query_params[:per_page] || RESULTS_PER_PAGE
  end

end