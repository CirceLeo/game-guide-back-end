class Game < ActiveRecord::Base
    has_many :game_relationships, dependent: :destroy
    has_many :users, through: :game_relationships
end