# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

before do
  @contents = File.readlines('data/toc.txt')
end

get '/' do
  @title = 'The Adventures of Sherlock Holmes'

  erb :home # layout: :layout
end

get '/chapters/:number' do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect '/' unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter # layout: :layout
end

get '/search' do
  chapter_files_paths = Dir.glob('data/chp*') # .map { |path| File.basename(path) }
  @search_term = params[:query]

  matching_files = chapter_files_paths.select do |path|
    chapter_text = File.read(path)
    chapter_text.include?(@search_term)
  end

  @matching_chap_nums = matching_files.map do |file|
    file.gsub(/\D/, '').to_i
  end

  erb :search
end

not_found do
  redirect '/'
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end
