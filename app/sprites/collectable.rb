class Collectable < MG::Sprite
  def self.new(file_name)
    instance = super
    instance.attach_physics_box
    instance.dynamic = false
    instance
  end
end
