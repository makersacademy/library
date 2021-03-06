require 'sinatra/base'
require 'googlebooks'
require 'sinatra/flash'
require_relative '../models/dmconfig'

class MainController < Sinatra::Base

  register Sinatra::Flash

  configure do
    use Rack::Session::Cookie, :key => 'rack.session',
                               :secret => 'hello my name is simon'

    set :root, Proc.new { File.join(File.dirname(__FILE__), "../../") }
  end

  before do
    @user = User.get(session[:user_id])
  end  

  get '/signup' do 
    @new_user = User.new
    erb :signup
  end

  post '/signup' do
    @new_user = User.new
    @new_user.first_name = params[:first_name]
    @new_user.last_name = params[:last_name]
    @new_user.email = params[:email]
    @new_user.password = params[:password]
    @new_user.password_confirmation = params[:password_confirmation]
    if @new_user.save
      session[:user_id] = @new_user.id
      redirect "/user/#{@new_user.id}"
    else
      erb :signup
    end
  end

  get '/login' do
    # @user = User.new
    erb :login
  end

  post '/login' do
    @user = User.first(:email => params[:email])
    if @user &&  @user.password == params[:password]
      session[:user_id] = @user.id
      redirect "/user/#{@user.id}"
    else
      # @user = nil
      flash[:info] = "Password and/or email incorrect"
      redirect '/login'
    end
  end

  get '/user/:id' do |id|
    erb :user_profile
  end

  get '/search_for_book' do 
    erb :search_for_book
  end  

  get '/display_results' do
    @count = (params[:count] || "10").to_i
    @page = (params[:page] || "1").to_i
    @search = params[:search]
    @books = GoogleBooks.search(params[:search], {:count => @count, :page => @page})
    erb :results
  end

  get '/logout' do
    session[:user_id] = nil
    redirect to('/')
  end

  get '/' do
    erb :home
  end

end


