class BackButton < MG::Button
  def self.create
    director = MG::Director.shared
    button = MG::Button.new("< Back")
    button.font = "Arial"
    button.font_size = 48
    button.anchor_point = [0, 1] # left, top
    button.position = [0, director.size.height] # left, top
    button.on_touch {|type| director.pop if type == :end }
    button
  end
end
