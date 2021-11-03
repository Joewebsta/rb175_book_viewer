# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  @contents = File.readlines('data/toc.txt')

  erb :home # layout: :layout
end

get '/chapters/:number' do
  @contents = File.readlines('data/toc.txt')

  number = params[:number]
  @title = "Chapter #{number}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter # layout: :layout
end
