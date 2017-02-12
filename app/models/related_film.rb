class RelatedFilm < ApplicationRecord
  # Generates list of id's of films related to
  # film of passed in id
  def self.related_films_for_film(film_id)
    array = self.find_by_sql(['SELECT related_film_id FROM related_films WHERE film_id = ?', film_id])
    return_array = Array.new
    array.each do |film|
      return_array.append film.related_film_id
    end

    return_array
  end
end
