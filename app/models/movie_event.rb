class MovieEvent < ApplicationRecord
  belongs_to :event
  belongs_to :movie
end
