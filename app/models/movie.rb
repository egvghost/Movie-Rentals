class Movie < ApplicationRecord
  belongs_to :genre
  has_many :movie_artists

  def self.import_movie_from_tmdb(tmdb_id)
    tmdb_movie = Tmdb::Movie.detail(tmdb_id)
    tmdb_movie_genre = tmdb_movie["genres"].first["name"]
    tmdb_movie_rating = Tmdb::Movie.releases(tmdb_id)
    movie_genre = Genre.find_or_create_by(name: tmdb_movie_genre)
    movie_credits = Tmdb::Movie.credits(tmdb_id) 
    movie = self.new
    movie.name = tmdb_movie["title"]
    movie.genre = movie_genre
    movie.release_date = tmdb_movie["release_date"]
    movie.cover_url = "https://image.tmdb.org/t/p/w400/#{tmdb_movie["poster_path"]}"
    movie.rating = tmdb_movie_rating["countries"].find{|c| c["iso_3166_1"] == "US"}["certification"]
    movie.save
    #byebug
    self.import_directors_from_tmdb movie_credits, movie
    self.import_producers_from_tmdb movie_credits, movie 
    self.import_cast_from_tmdb movie_credits, movie
    movie
  end

  private

  def self.import_directors_from_tmdb(credits, m)
    #byebug
    director = credits["crew"].find{|c| c["job"] == "Director"}.select{|k,v| k == "name"}   
    artist = Artist.find_or_create_by(name: director["name"])
    MovieArtist.find_or_create_by(role: "Director",movie: m, artist: artist) 
  end

  def self.import_producers_from_tmdb(credits, m)
    crew = {}
    #byebug
    for i in 0..credits["crew"].size-1
      if credits["crew"][i]["job"] == "Producer" then 
        crew[i] = credits["crew"][i]["name"] 
        artist = Artist.find_or_create_by(name: crew[i])
        MovieArtist.find_or_create_by(role: "Producer",movie: m, artist: artist)  
      end
    end 
  end

  def self.import_cast_from_tmdb(credits, m)
    cast = {}
    for i in 0..credits["cast"].size-1
      cast[credits["cast"][i]["character"]] = credits["cast"][i]["name"]    
      artist = Artist.find_or_create_by(name: credits["cast"][i]["name"])
      MovieArtist.find_or_create_by(role: "Cast",movie: m, artist: artist)   
    end
  end

end
