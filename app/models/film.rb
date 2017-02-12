class Film < ApplicationRecord
  # Saves user rating for a specific film.
  # user_id - id of user
  # rating - numerical rating
  def set_rating_for_user(user_id, rating)
    user = User.find_or_create_by(:id => user_id)
    film_rating = FilmRating.find_or_create_by(:film_id => self.id, :user_id => user.id)
    film_rating.update(:rating => rating)
  end

  # Retrieves this film's average user rating
  def average_user_rating
    FilmRating.average_user_rating(self.id)
  end

  # The API data type of this object
  def type
    :film
  end

  # Retrieves list of films related to this one
  def related_film_ids
    RelatedFilm.related_films_for_film(self.id)
  end

  # List of attributes to expose through the API
  def properties
    attributes = Hash.new
    attributes[:title] = self.title
    attributes[:description] = self.description
    attributes[:url_slug] = self.url_slug
    attributes[:year] = self.year
    attributes[:related_film_ids] = related_film_ids
    attributes[:average_rating] = average_user_rating
    attributes
  end

  def as_json(options={})
    super(options.merge(:only => [:id], :methods => [:properties, :type]))
  end
end
