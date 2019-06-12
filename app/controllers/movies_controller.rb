class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:new, :edit, :create, :update, :destroy, :import, :api_search_results, :api_search]
  
  # GET /movies
  # GET /movies.json
  def index
    @permited_movies = Movie.permited(current_user.age).order(:name).page params[:page]
    @permited_movies = @permited_movies.where(active: true) unless current_user.is_admin?
    @movies = if params[:q]
      @permited_movies.where('name LIKE ?', "%#{params[:q]}%")
    else
      @movies = @permited_movies
    end
  end

  def api_search
  end

  def api_search_results
    movie_name = params["name"] if params["name"] != "" #o unless params["name"].blank?
    release_year = params["release_year"] unless params["release_year"].blank?
    search = Tmdb::Search.new
    search.resource 'movie' # ----> search.resource('movie')
    search.year release_year
    search.query movie_name
    @results = search.fetch
  end

  def import
    tmdb_id = params["tmdb_id"] if params["tmdb_id"] != ""
    @movie = Movie.import_movie_from_tmdb(tmdb_id)
    if @movie #si la puede crear devuelve 'true', sino 'false'. El if evalua por false/true
      redirect_to @movie, notice: "Movie was successfully created"
    else
      redirect_to import_error_movies_path, notice: "Movie could not be created (#{@movie.errors.messages})"
    end

  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
    @genres = Genre.all
  end

  # GET /movies/1/edit
  def edit
    @genres = Genre.all
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      begin 
        @movie = Movie.permited(current_user.age).find(params[:id])
        (if !@movie.is_active? 
          flash[:danger] = "The movie you are trying to access is not available"
          redirect_to movies_url
        end) unless current_user.is_admin?
      rescue 
        flash[:danger] = "You are not authorized to access this movie"
        redirect_to movies_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:name, :movie_url, :release_date, :rating, :cover_url, :genre_id, :active)
      #whitelist creada para permitir SÓLO los parámetros listados, durante el POST del form
    end

    def verify_if_admin_and_redirect_with_error_message_if_not
      unless current_user.is_admin?
        flash[:danger] = "You are not authorized to perform this action"
        redirect_to movies_url
      end
    end
    
end
