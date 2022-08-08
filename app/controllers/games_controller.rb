class GamesController < ApplicationController

  def new
    grid = []
    10.times do
      grid << ('a'..'z').to_a.sample
    end
    @letters = grid
  end

  def score
    binding.pry
  end
end
