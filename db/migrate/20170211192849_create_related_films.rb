class CreateRelatedFilms < ActiveRecord::Migration[5.0]
  def change
    create_table :related_films, id: false do |t|
      t.integer :film_id
      t.integer :related_film_id
    end

    add_foreign_key(:related_films, :films, column: :film_id, primary_key: :film_id)
    add_foreign_key(:related_films, :films, column: :related_film_id, primary_key: :film_id,
                    name: 'fk_rails_related_film_id')
  end
end
