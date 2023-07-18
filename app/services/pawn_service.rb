# frozen_string_literal: true

# app/services/pawn_service.rb

class PawnService
  VALID_DIRECTIONS = %w[NORTH SOUTH EAST WEST].freeze

  def initialize
    @x = nil
    @y = nil
    @facing = nil
    @color = nil
    @output = nil
    @coordinates = []
  end

  def process_commands(commands)
    @first_move = false
    commands.map do |command|
      command = command.chomp.split
      case command[0]
      when 'PLACE'
        args = command[1].split(',')
        place(args[0].to_i, args[1].to_i, args[2], args[3])
        @first_move = true
        @coordinates = []
      when 'MOVE'
        if @first_move
          move(move_squares(command[1]))
          @first_move = false
        else
          move
        end
      when 'LEFT'
        left
      when 'RIGHT'
        right
      when 'REPORT'
        report
      end
      @coordinates << ["cord-#{@x}-#{@y}", @facing.downcase] unless command[0].eql?('REPORT')
    end

    [@output, @coordinates]
  end

  def move_squares(times)
    return times.to_i if [1, 2].include?(times.to_i)

    1
  end

  def place(x, y, facing, color)
    return unless valid_position?(x, y) && VALID_DIRECTIONS.include?(facing)

    @x = x
    @y = y
    @facing = facing
    @color = color
  end

  def move(times = 1)
    return unless placed?

    case @facing
    when 'NORTH'
      @y += times if valid_position?(@x, @y + times)
    when 'SOUTH'
      @y -= times if valid_position?(@x, @y - times)
    when 'EAST'
      @x += times if valid_position?(@x + times, @y)
    when 'WEST'
      @x -= times if valid_position?(@x - times, @y)
    end
  end

  def left
    return unless placed?

    @facing = case @facing
              when 'NORTH' then 'WEST'
              when 'EAST' then 'NORTH'
              when 'SOUTH' then 'EAST'
              when 'WEST' then 'SOUTH'
              end
  end

  def right
    return unless placed?

    @facing = case @facing
              when 'NORTH' then 'EAST'
              when 'EAST' then 'SOUTH'
              when 'SOUTH' then 'WEST'
              when 'WEST' then 'NORTH'
              end
  end

  def report
    return unless placed?

    @output = "#{@x},#{@y},#{@facing},#{@color}"
  end

  private

  def valid_position?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def placed?
    !(@x.nil? || @y.nil? || @facing.nil? || @color.nil?)
  end
end
