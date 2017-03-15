class Hero < Character
  def self.new(file_name = "hero.png")
    instance = super
    instance.dynamic = true
    instance
  end
end
