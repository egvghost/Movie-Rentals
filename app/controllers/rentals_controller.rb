class RentalsController < ApplicationController
  before_action :set_movie, only: [:new, :create]
  before_action :verify_if_admin_and_redirect_with_error_message_if_yes, only: [:new, :create]

  def index
  end

  def show

  end

  def new
    @rental = generate_new_rental
  end

  def create
    @rental = generate_new_rental
    @rental.movie = @movie
    @rental.user = current_user

    if @rental.save
      redirect_to @rental, notice: "You have successfully rented #{@movie.name}"
    else
      redirect_to movies_path, notice: "There was an error performing the operation. #{@rental.errors.first.last}"
    end

  end

  private
  
  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
  
  def generate_new_rental
    rental = Rental.new
    rental.valid_from = Time.now
    rental.valid_to = rental.valid_from + 2.days
    rental
  end

  def verify_if_admin_and_redirect_with_error_message_if_yes
    if current_user.is_admin?
      flash[:danger] = "You are not authorized to perform this action"
      redirect_to movies_url
    end
  end
  
end
