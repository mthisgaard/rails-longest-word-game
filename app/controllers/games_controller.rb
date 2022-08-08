require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    vowels = %w[A E I O U Y]
    grid = []
    5.times do
      grid << vowels.sample
      grid << (('A'..'Z').to_a - vowels).sample
    end
    @letters = grid.shuffle
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    @points = points(@word, @included, @english_word)
    #@total = total_score(@points)
  end

  private

  # def total_score(points)
  #   if points.zero? && session[:total_score].nil?
  #     0
  #   else
  #     session[:total_score] = points
  #   end
  # end

  def points(word, included, english_word)
    if included && english_word
      word.length
    else
      0
    end
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
