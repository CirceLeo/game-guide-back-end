class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  get "/games" do
    Game.all.order(:title).to_json
  end

  get "/games/random" do
    random = Game.find(Game.last.id)
    random.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])
    game.to_json(include: {game_relationships: {include: {user: {include: :profile_pic}}}})
  end

  get '/games_with_comments' do
    Game.all.to_json(include: {game_relationships: {include: {user: {include: :profile_pic}}}})
  end

  get '/get_similar_games/:id' do
    game = Game.find(params[:id])
    similar = game.find_similar_games
    similar.to_json
  end
  
  get '/search/:playtime/:num_players' do
    game = Game.all.filter{ |g| 
      g.title.downcase.include?(params[:name].downcase) &&
      g.max_play_time <= params[:playtime].to_i &&
      g.min_players <= params[:num_players].to_i
      }
    game.to_json(include: {game_relationships: {include: {user: {include: :profile_pic}}}})
  end

  get '/search/:name/:playtime/:num_players' do
      game = Game.all.filter{ |g| 
        g.title.downcase.include?(params[:name].downcase) &&
        g.max_play_time <= params[:playtime].to_i &&
        g.min_players <= params[:num_players].to_i
        }
      game.to_json(include: {game_relationships: {include: {user: {include: :profile_pic}}}})
  end


  get '/users' do
    User.all.to_json
  end

  get '/users/:id' do
    user = User.find(params[:id])
    user.to_json(include: {game_relationships: {include: :game}})
  end

  get '/users/by-username/:username' do
    user = User.find_by(username: params[:username])
    user.to_json(include: [{game_relationships: {include: :game}}, :profile_pic])
  end
  #game relationship
  get '/game_relationships' do
    GameRelationship.all.order(:user_id).to_json
  end

  #gets all messages based on user's id 
  get '/messages/:id' do
    Message.where(user_id: params[:id])
  end
  
  #Profile pics

  get '/profile_pics' do
    ProfilePic.all.to_json
  end





  delete '/users/:id' do
    user = User.find(params[:id])
    user.destroy
    user.to_json
  end

  delete '/games/:id' do
    game = Game.find(params[:id])
    game.destroy
    game.to_json
  end

  
  delete '/messages/:id' do
    message = Message.find(params[:id])
    message.destroy
    message.to_json
  end


  post '/game_relationships' do
    game_relatinship = GameRelationship.create(
      user: params[:user],
      game: params[:game],
      owned?: params[:owned?],
      played?: params[:played?],
      liked?: params[:liked?],
      comment: params[:comment],
      hours_played: params[:hours_played]
    )
    game_relatinship.to_json
  end

  post '/users' do
    user = User.create(
      password: params[:password],
      username: params[:username],
      profile_pic_id: params[:profile_pic_id]
    )
    user.to_json
  end

  post 'messages' do
    message = Message.create(
      user: params[:user],
      content: params[:content]
    )
    message.to_json
  end


  patch 'users/:id' do
    user = User.find(params[:id])
    user.update(profile_pic_id: params[:profile_pic_id])
    user.to_json
  end

  #messages all show up by create table
  #messages have user_to and user_from?

  #stand in for when we make game relationships editable
  #change comment
  # patch 'game_relationship/:id' do
  #   game_relationship = GameRelationship.find(params[:id])
  #   game_relationship.update()
  #   game_relatinship.to_json
  # end

end
