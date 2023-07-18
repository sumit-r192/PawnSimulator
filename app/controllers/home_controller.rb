# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @output = ''
    @commands = params[:commands]&.split("\n") || []
    process_data if params[:submit]
  end

  private

  def process_data
    pawn = PawnService.new
    commands = @commands.reject(&:blank?).map(&:upcase)
    @output, @cordinates = pawn.process_commands(commands)
  end
end
