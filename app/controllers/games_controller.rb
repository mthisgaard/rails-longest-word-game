require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid = []
    10.times do
      grid << ('a'..'z').to_a.sample
    end
    @letters = grid
  end

  def score
    params[:word] = params[:word].upcase
    score = params[:word].length
    if session[:total_score].nil?
      session[:total_score] = score
    else
      session[:total_score] += score
    end
    @result =
      if params[:word].upcase.chars.all? { |letter| params[:word].count(letter) <= params[:letters].count(letter) }
        [0, session[:total_score], "Sorry but #{params[:word]} can't be built out of #{params[:letters].gsub(' ', ', ').upcase}"]
      elsif !english_word?(params[:word])
        [0, session[:total_score], "Sorry but #{params[:word]} does not seem to be a valid English word..."]
      else
        [score, session[:total_score], "Congratulations! #{params[:word]} is a valid English word!"]
      end
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
