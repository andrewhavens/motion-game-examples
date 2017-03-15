class ColorDotsAdvanceExample < MG::Scene
  def initialize
    @score = 0
    @dots = []

    @director ||= MG::Director.shared

    add(BackButton.create)
    add_description_label
    add_score_label

    on_touch_begin { |event| touch_handler(event) }

    @dots = []
    @schedule_key = schedule(0, MG::Repeat::FOREVER, 1.25) { |delta| game_loop }
  end

  def game_loop
    @dots.map! { |dot| increase_size(dot) }

    # Check for lost
    idx = @dots.find_index { |dot| 140 <= dot[:size] }

    unless idx.nil?
      unschedule(@schedule_key)
      @description_label.text = "Game lost"
    end

    create_new_dot
  end

  def touch_handler(event)
    idx = @dots.rindex { |dot| dot_tapped?(event.location, dot[:position], dot[:size]) }

    unless idx.nil?
      delete, new_dot = decrease_size(@dots[idx])

      if delete
        @dots.delete_at(idx)
        increase_score
      else
        @dots[idx] = new_dot
      end
    end
  end

  def random_spawn_point
    [rand(0..@director.size.width), rand(0..@director.size.height)]
  end

  def create_new_dot
    position = random_spawn_point
    size = 40
    color = [rand(0.0..1.0), rand(0.0..1.0), rand(0.0..1.0), 1]
    # Draw returns MG::Draw, which we can only use for clear. We have to draw new circle when we increase size.
    draw_node = MG::Draw.new.dot(position, size, color)
    draw_node.dot(position, size, color)
    @dots << { draw_node: draw_node, position: position, size: size, color: color }
    add(draw_node)
  end

  def dot_tapped?(tap_position, dot_position, dot_size)
    tap_position.distance(dot_position) < dot_size
  end

  def increase_size(dot)
    draw_node = dot[:draw_node]
    position = dot[:position]
    new_size = dot[:size] + 20
    color = dot[:color]

    draw_node.clear
    draw_node.dot(position, new_size, color)
    { draw_node: draw_node, position: position, size: new_size, color: color }
  end

  # Returns TRUE if we have to delete else FALSE.
  def decrease_size(dot)
    draw_node = dot[:draw_node]
    position = dot[:position]
    new_size = dot[:size] - 10
    color = dot[:color]

    draw_node.clear

    if new_size == 20
      return true, nil
    else
      draw_node.dot(position, new_size, color)
      return false, { draw_node: draw_node, position: position, size: new_size, color: color }
    end
  end

  def add_description_label
    @description_label = MG::Text.new("Tap the dots! Before it is to late!", "Arial", 72)
    @description_label.position = [@director.size.width / 2, @director.size.height / 2]
    add(@description_label)
  end

  def add_score_label
    @score_label = MG::Text.new("Score: #{@score}", "Arial", 50)
    @score_label.position = [@director.size.width / 2, @director.size.height - 30]
    add(@score_label)
  end

  def increase_score
    @score += 1
    @score_label.text = "Score: #{@score}"
  end
end
