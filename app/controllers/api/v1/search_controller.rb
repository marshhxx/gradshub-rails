class Api::V1::SearchController < ApplicationController

  # supported key words: interests, skills, job_titles
  def show
    @users = User.search(query_params[:q], query_params[:max])
    render :show, status: :ok
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:q, :max, :per_page)
  end

end