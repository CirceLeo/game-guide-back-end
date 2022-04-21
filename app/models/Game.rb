class Game < ActiveRecord::Base
    has_many :game_relationships, dependent: :destroy
    has_many :users, through: :game_relationships

    def mechanic_array
        self.mechanics.split(",")
    end

    def share_any_mechanics mechanics_string
        ever_appear = false
        self.mechanic_array.each do |mechanic| 
            if mechanics_string.include?(mechanic) 
                ever_appear = true
            end
        end
        ever_appear
    end

    def share_any_categories categories_string
        ever_appear = false
        self.categories.split(",").each do |category| 
            if categories_string.include?(category) 
                ever_appear = true
            end
        end
        ever_appear
    end


    def find_similar_games 
        sim_games = Game.all.filter do |g| 
            g.max_play_time <= self.max_play_time + 10 &&
            g.max_players <= self.max_players + 2 &&
            (self.share_any_mechanics(g.mechanics) ||
            self.share_any_categories(g.categories)) &&
            g.id != self.id
        end
        sim_games
    end

    def get_all_comments
        comments = self.game_relationships.map do |relationship|
            relationship.comment + "  -  " + relationship.user.username
        end
        comments
    end

    def self.get_a_random_game
        Game.all.sample
    end

end