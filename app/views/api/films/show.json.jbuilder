json.data do
  json.id @film.id
  json.type @film.type
  json.attributes do
    if @fields_to_display.count > 0
      @fields_to_display.each do |field|
        if field.eql? 'title'
          json.title = @film.title
        end

        if field.eql? 'description'
          json.description = @film.description
        end

        if field.eql? 'url_slug'
          json.url_slug = @film.url_slug
        end

        if field.eql? 'year'
          json.year = @film.year
        end

        if field.eql? 'related_film_ids'
          json.related_film_ids = @film.related_film_ids
        end

        if field.eql? 'average_rating'
          json.average_rating = @film.average_user_rating
        end
      end
    else
      json.(@film, :title, :description, :url_slug, :year)
      json.related_film_ids @film.related_film_ids
      json.average_rating @film.average_user_rating
    end
  end
end