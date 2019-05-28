class RentalsController < ApplicationController
  before_action :set_movie, only: [:new, :create]

  def index
  end

  def show

  end

  def new
    @rental = Rental.new
    @rental.valid_from = Time.now
    @rental.valid_to = @rental.valid_from + 2.days
  end

  def create
    @rental = Rental.new
    @rental.valid_from = Time.now
    @rental.valid_to = @rental.valid_from + 2.days
    @rental.movie = @movie
    @rental.user = current_user

    if @rental.save
      redirect_to @rental, notice: "You have successfully rented #{@movie.name}"
    else
      redirect_to @movies, notice: "There was an error performing this operation. #{@rental.errors.first.last}"
    end
  end

  private
  #Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

end
