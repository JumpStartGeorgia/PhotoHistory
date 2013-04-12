class RootController < ApplicationController

  def index
    @pairing = Pairing.first
  end

end
