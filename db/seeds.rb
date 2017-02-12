# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
json = ActiveSupport::JSON.decode(File.read('db/films.json'))

Film.find_by_sql('DELETE FROM users')
Film.find_by_sql('DELETE FROM film_ratings')
Film.find_by_sql('DELETE FROM films')

json['films'].each do |film|
  Film.create(
      :id => film['id'],
      :title => film['title'],
      :description => film['description'],
      :url_slug => film['url_slug'],
      :year => film['year'])
end

json['films'].each do |film|
  film['related_film_ids'].each do |related_id|
    RelatedFilm.create(
        :film_id => film['id'],
        :related_film_id => related_id)
  end
end