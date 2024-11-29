require 'open-uri'
class MoviesController < ApplicationController
  def index
  end

  def show
  end

  def search
    url = "https://api.themoviedb.org/3/search/movie?query=#{params[:query]}&api_key=#{ENV['TMDB_API_KEY']}&language=fr-FR&page=1"

    response = URI.open(url).read
    json = JSON.parse(response)

    respond_to do |format|
      format.json {
        render json: { response: json }
      }
    end
  end
end
