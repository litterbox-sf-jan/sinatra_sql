require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'

# configure do
  set :conn, PG.connect( dbname: 'testing' )
# end

before do
  @conn = settings.conn
end

get '/' do
  users = []
  @conn.exec("SELECT * FROM authors") do |result|
    result.each do |row|
        users << row
    end
  end
  @users = users
  erb :hi
end

get '/add' do
  erb :add
end

post '/add' do
  @conn.exec('INSERT INTO authors (name) values ($1)', [ params[:user] ] )
  redirect '/'
end

get '/edit/:id' do
  id = params[:id].to_i
  user = @conn.exec('SELECT * FROM authors WHERE id = ($1)', [ id ] )
  binding.pry
  @user = user[0]
  erb :edit
end

put '/edit/:id' do
  id = params[:id].to_i
  @conn.exec('UPDATE authors SET (name) = ($1) WHERE id = ($2)', [ params[:user], id ] )
  redirect '/'
end

delete '/delete/:id' do
  id = params[:id].to_i
  @conn.exec('DELETE FROM authors WHERE id = ($1)', [ id ] )
  redirect '/'
end