# require 'digest'

get '/' do
  erb :login, :layout => false
  #erb :index
end

get '/profile/:user_name' do
  @user = User.find_by(user_name: params[:user_name])
  @hash_email = hash_email(@user.email)
    # @tweet_objects = @tweet_objects.sort_by{|tweet_object| tweet_object.created_at}.reverse

  erb :profile
end

# for header new tweets in profile & timeline
post '/tweet/:user_name' do
  @user = User.find_by(user_name: params[:user_name])
  @tweet = Tweet.create(user_id: @user.id, content: params[:content])
  redirect "/profile/#{@user.user_name}"
end








# # for header new tweets in profile & timeline
# post '/timeline/:user_name' do
#   @user = User.find(params[:user_name])
#   @tweet = Tweet.create(user_id: @user.id, content: params[:content])
#   redirect'/timeline/:user_name'
# end


# get '/tweet/:user_name' do
#   @tweet = Tweet.find_by user_name: params[:user_name]
#   #delete option on this page
#   #link back to timeline & profile on this page
#   erb :tweet
# end

get '/remove_tweet/:id' do
  Tweet.destroy(params[:id])
  redirect "/find_user"
end

get '/follow/:user_name' do
  #both your followers & who you follow
  @user = User.find_by(user_name: params[:user_name])
  @followers = Following.where(user_id: @user.id)
  @the_followers = []
  @followers = @followers.each {|i| @the_followers << User.find_by(id: i.followed_by)}
  #returns list of objects for specific user.. Erb will get followers ids

  @following = Following.where(followed_by: @user.id)
  @those_who_follow = []
  @following = @following.each {|i| @those_who_follow << User.find_by(id: i.user_id)}
  erb :follow
end

post '/start_following/:user_name' do
  @user = User.find_by(user_name: params[:user_name])
  Following.create(user_id: @user.id, followed_by: session[:user_id])
  redirect "/profile/#{@user.user_name}"
end

post '/search/' do
  @tweet_objects = []
  Tweet.all.each do  |tweet|
    if tweet.content.include?(params[:item])
      @tweet_objects << tweet
    end
  end

  erb :search
end

get '/search/:search_item' do
  erb :search
end



get "/find_user" do
  @user =  User.find(session[:user_id])
  redirect "/profile/#{@user.user_name}"
end


get '/timeline/:user_name' do
  @user = User.find_by(user_name: params[:user_name])
  @tweet_objects = []
  Following.all.each do |follower|
    if follower.followed_by == @user.id
      @person = User.find(follower.user_id)
     @tweet_objects << Tweet.where(user_id: @person.id)
     p @tweet_objects
    end
  end

  # @followers = Following.where(user_id: @user.id)
  # @follower_ids = []
  # @followers.all.each {|follower|  @follower_ids << follower.followed_by }
  # @tweet_objects = []

  # @follower_ids.each {|user_id| @tweet_objects << Tweet.where(user_id: user_id)}
  # @tweet_objects = @tweet_objects.flatten.sort_by{|tweet_object| tweet_object.created_at}.reverse
  # @tweets = @user_objects.user_id.tweet

  erb :timeline
end


def hash_email(email)
  hash = Digest::MD5.hexdigest(email.downcase.strip)
  #1b98c6f2d8425d7312eeb13724b39cb5?s=200
end



# ============SESSIONS
# get '/secret' do
#   if !logged_in?
#     redirect '/timeline/:user_name'
#   end
#   erb :secret
# end

post '/signup' do

  @user = User.create(params[:data])

    session[:user_id] = @user.id

  redirect "/timeline/#{@user.user_name}"
end


post '/login' do

  # raise params.inspect

  @user = User.find_by(email: params[:data][:email])

    session[:user_id] = @user.id

    redirect "/timeline/#{@user.user_name}"

  # if @user && @user.authenticate(params[:password])
  #   session[:user_id] = @user.id
  #   redirect '/timeline/:user_name'
  # else
  #   redirect '/'
  # end

end

get '/logout' do
  session[:user_id]=nil
  redirect '/'
end

