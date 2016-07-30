class ExamplesList < MG::Scene
  def initialize
    add_option "Color Dots", ColorDotsExample
    add_option "Walking Sprite", WalkingSpriteExample
  end

  def add_option(label_text, scene_class)
    @options_count ||= 0
    @director ||= MG::Director.shared
    button = MG::Button.new(label_text)
    button.font = "Arial"
    button.font_size = 60
    button.anchor_point = [0.5, 1] # center, top
    button.position = [@director.size.width / 2, @director.size.height - 20 - (@options_count*70)]
    button.on_touch {|type| @director.replace(scene_class.new) if type == :end }
    add(button)
    @options_count += 1
  end
end
