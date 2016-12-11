class WalkingSpriteExample < MG::Scene
  def initialize
    add_back_button
    add_character
  end

  def add_back_button
    director ||= MG::Director.shared
    button = MG::Button.new("< Back")
    button.font = "Arial"
    button.font_size = 48
    button.anchor_point = [0, 1] # left, top
    button.position = [0, director.size.height] # left, top
    button.on_touch {|type| director.pop if type == :end }
    add(button)
  end

  def add_character
    director = MG::Director.shared
    screen_width = director.size.width
    screen_height = director.size.height

    @hero = MG::Sprite.new("hero.png")
    @hero.position = [screen_width / 2, screen_height / 2]
    frames = [1, 2, 3, 4, 3, 2].map {|i| "hero_walk#{i}.png"}
    @hero.animate(frames, 0.15, :forever)
    @hero.scale = 2
    add @hero

    on_touch_begin do |event|
      @hero.flipped_horizontally = moved_left?(event.location)
      @hero.move_to(event.location, 1)
    end
  end

  def moved_left?(new_location)
    new_location.x < @hero.position.x
  end
end
