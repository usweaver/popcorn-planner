class CreateMovieComments < ActiveRecord::Migration[7.1]
  def change
    create_table :movie_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie_event, null: false, foreign_key: true
      t.text :comment
      t.float :rating

      t.timestamps
    end
  end
end
