class ChairsController < ApplicationController
  def index
    @chairs = Chair.all
  end
end
