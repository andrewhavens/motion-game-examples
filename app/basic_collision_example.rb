class BasicCollisionExample < MG::Scene
  DOT = 1 << 0
  CHARACTER = 1 << 1

  def initialize
    self.debug_physics = true
    self.gravity = [0, 0]
    add(BackButton.create)
    add_character

    @bad_guy = MG::Sprite.new("hero.png")
    @bad_guy.position = [100, 100 / 2]
    @bad_guy.attach_physics_box
    @bad_guy.dynamic = false
    @bad_guy.category_mask = CHARACTER
    @bad_guy.contact_mask = DOT
    add(@bad_guy)

    @other_guy = MG::Sprite.new("hero.png")
    @other_guy.position = [200, 200 / 2]
    @other_guy.attach_physics_box
    @other_guy.dynamic = false
    @other_guy.category_mask = CHARACTER
    @other_guy.contact_mask = DOT
    add(@other_guy)

    on_contact_begin do |contact_event|
      puts "intersected with bad guy: #{@hero.intersects?(@bad_guy).inspect}"
      puts "intersected with good guy! #{@hero.intersects?(@other_guy).inspect}"
    end
  end

  def add_character
    director = MG::Director.shared
    screen_width = director.size.width
    screen_height = director.size.height

    @hero = MG::Sprite.new("hero.png")
    @hero.attach_physics_box
    @hero.dynamic = true
    @hero.category_mask = DOT
    @hero.contact_mask = CHARACTER
    @hero.position = [screen_width / 2, screen_height / 2]
    @hero.scale = 2
    add @hero

    on_touch_begin do |event|
      @hero.stop_all_actions # cancel any moves in progress since our destination has changed
      new_location = event.location
      distance = @hero.position.distance(new_location)
      speed = distance / 150 # move at a rate of 150 points per second
      @hero.flipped_horizontally = moved_left?(new_location)
      @hero.move_to(new_location, speed)
      frames = [1, 2, 3, 4, 3, 2].map {|i| "hero_walk#{i}.png"}
      @hero.animate(frames, 0.15, MG::Repeat::FOREVER)
      # FIXME: use a Sequence instead of a DelayTime action
      @hero.run_action(MG::DelayTime.new(speed)) do
        @hero.stop_all_actions # stop walking animation
        @hero.animate(["hero.png"], 1, MG::Repeat::FOREVER)
      end
    end
  end

  def moved_left?(new_location)
    new_location.x < @hero.position.x
  end

end
