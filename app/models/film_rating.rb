class FilmRating < ApplicationRecord
  # Computes the average user rating for a film using an sql query.
  # Returns zero if no rating exists yet.
  def self.average_user_rating(film_id)
    array = self.find_by_sql(['SELECT max(avg(rating),0) as avg_rating FROM film_ratings WHERE film_id = ?', film_id])
    array[0].avg_rating != nil ? array[0].avg_rating : 0
  end
end
