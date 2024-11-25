class CreateMovieEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :movie_events do |t|
      t.references :event, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.boolean :selected_movie, default: false

      t.timestamps
    end
  end
end
