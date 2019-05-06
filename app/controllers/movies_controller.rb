class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
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
    tmdb_movie = Tmdb::Movie.detail(tmdb_id)
    tmdb_movie_genre = tmdb_movie["genres"].first["name"]
    tmdb_movie_rating = Tmdb::Movie.releases(tmdb_id)
    movie_genre = Genre.find_or_create_by(name: tmdb_movie_genre)

    @movie = Movie.new
    @movie.name = tmdb_movie["title"]
    @movie.genre = movie_genre
    @movie.release_date = tmdb_movie["release_date"]
    @movie.cover_url = "https://image.tmdb.org/t/p/w400/#{tmdb_movie["poster_path"]}"
    @movie.rating = tmdb_movie_rating["countries"].find{|c| c["iso_3166_1"] == "US"}["certification"]

    if @movie.save #si la puede crear devuelve el objeto, sino 'false'. El if evalua por false/true
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
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:name, :movie_url, :release_date, :rating, :cover_url, :genre_id)
      #whitelist creada para permitir SÓLO los parámetros listados, durante el POST del form
    end
end
