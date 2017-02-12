class CreateFilms < ActiveRecord::Migration[5.0]
  def change
    create_table :films do |t|
      t.text :title
      t.text :description
      t.text :url_slug
      t.integer :year
      t.timestamps
    end
  end
end
