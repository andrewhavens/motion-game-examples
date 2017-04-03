class AdvancedCollisionExample < MG::Scene
  HERO        = 1 << 0
  CHARACTER   = 1 << 1
  ENEMY       = 1 << 2
  COLLECTABLE = 1 << 3

  def initialize
    # self.debug_physics = true
    self.gravity = [0, 0]
    add(BackButton.create)
    add_hero
    add_enemy
    add_other_character
    add_coin

    @collected_coins = 0

    on_contact_begin do |contact_event|
      if @hero.intersects?(@coin)
        @collected_coins += 1
        puts "Collected coin. Total = #{@collected_coins}"
        delete @coin
      end
      if @hero.intersects?(@enemy)
        puts "intersected with bad guy!"
        game_over_sequence
      end
      puts "intersected with good guy!" if @hero.intersects?(@other_guy)
    end
  end

  def add_hero
    director = MG::Director.shared
    screen_width = director.size.width
    screen_height = director.size.height

    @hero = Hero.new
    @hero.category_mask = HERO
    # @hero.collision_mask = 0
    @hero.contact_mask = ENEMY | CHARACTER | COLLECTABLE
    @hero.position = [screen_width / 2, screen_height / 2]
    add @hero

    on_touch_begin do |event|
      @hero.walk_to(event.location) unless @game_over
    end
  end

  def add_enemy
    @enemy = Character.new
    @enemy.position = [300, 150]
    @enemy.category_mask = ENEMY
    @enemy.contact_mask = HERO
    add(@enemy)
    @enemy.walk_around
  end

  def add_other_character
    @other_guy = Character.new
    @other_guy.position = [200, 100]
    @other_guy.category_mask = CHARACTER
    @other_guy.contact_mask = HERO
    add(@other_guy)
  end

  def add_coin
    @coin = Coin.new
    @coin.position = [800, 100]
    @coin.category_mask = COLLECTABLE
    @coin.contact_mask = HERO
    add(@coin)
  end

  def game_over_sequence
    return if @game_over
    @game_over = true
    @enemy.stop_all_actions
    @hero.stop_all_actions
    @hero.rotate_by 720, 2
  end
end
