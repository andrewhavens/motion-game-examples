class Character < MG::Sprite
  def self.new(file_name = "hero.png")
    instance = super
    instance.attach_physics_box
    instance.dynamic = false
    instance.scale = 2
    instance
  end

  def walk_around
    x = rand(10..500)
    y = rand(10..500)
    walk_to MG::Point.new(x, y) do
      walk_around
    end
  end

  def time_to_walk_to(new_location)
    distance = position.distance(new_location)
    distance / 150 # move at a rate of 150 points per second
  end

  def walk_to(new_location, &block)
    stop_all_actions # cancel any moves in progress since our destination has changed
    self.flipped_horizontally = moved_left?(new_location)
    duration = time_to_walk_to(new_location)
    move_to(new_location, duration)
    run_walk_animation(duration, &block)
  end

  def run_walk_animation(duration, &block)
    frames = [1, 2, 3, 4, 3, 2].map {|i| "hero_walk#{i}.png"}
    animate(frames, 0.15, MG::Repeat::FOREVER)
    # FIXME: use a Sequence instead of a DelayTime action
    run_action(MG::DelayTime.new(duration)) do
      stop_all_actions # stop walking animation
      animate(["hero.png"], 1, MG::Repeat::FOREVER)
      block.call if block
    end
  end

  def moved_left?(new_location)
    new_location.x < position.x
  end
end
