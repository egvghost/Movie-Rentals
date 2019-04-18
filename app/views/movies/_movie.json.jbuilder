json.extract! movie, :id, :name, :movie_url, :year, :parental_guidante_rate, :cover_url, :created_at, :updated_at
json.url movie_url(movie, format: :json)
