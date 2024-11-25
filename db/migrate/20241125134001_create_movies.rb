class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :synopsis
      t.string :poster_url
      t.integer :classification
      t.string :director
      t.integer :duration
      t.string :category

      t.timestamps
    end
  end
end
