class Coin < Collectable
  def self.new(file_name = "coin.png")
    instance = super
    instance.scale = 0.25
    instance
  end
end
