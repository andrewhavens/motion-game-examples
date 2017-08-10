class AnimatedSpriteExample < MG::Scene

  def initialize
    add(BackButton.create)

    MG::Sprite.load("bitcoin.plist")
    @new_coin = MG::Sprite.new("frame_0_delay-0.1s.gif")
    @new_coin.position = center_point
    @new_coin.scale = 0.75
    frames = (0..5).map {|i| "frame_#{i}_delay-0.1s.gif"}
    @new_coin.animate(frames, 0.1, MG::Repeat::FOREVER)
    add(@new_coin)
  end

  def center_point
    director = MG::Director.shared
    screen_width = director.size.width
    screen_height = director.size.height
    [screen_width / 2, screen_height / 2]
  end
end
