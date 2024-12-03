class AddEventToVote < ActiveRecord::Migration[7.1]
  def change
    add_reference :votes, :event, foreign_key: true
  end
end
