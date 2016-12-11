class ColorDotsExample < MG::Scene
  def initialize
    add_back_button
    add_label
    on_touch_begin { |event| draw_dot(event.location) }
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

  def add_label
    window_size = MG::Director.shared.size
    label = MG::Text.new("Start Tapping!", "Arial", 72)
    label.position = [window_size.width / 2, window_size.height / 2]
    add(label)
  end

  def draw_dot(location)
    color = [rand(0.0..1.0), rand(0.0..1.0), rand(0.0..1.0), 1]
    size = rand(10..40)
    dot = MG::Draw.new.dot(location, size, color)
    add(dot)
  end
end
