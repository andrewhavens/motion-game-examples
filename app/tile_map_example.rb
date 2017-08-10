class TileMapExample < MG::Scene
  def initialize
    director = MG::Director.shared
    screen_width = director.size.width
    screen_height = director.size.height

    add(BackButton.create)
    self.gravity = [0, 0]

    $tilemap = tilemap = MG::TileMap.load("demo.tmx")
    tilemap.scale = 2
    add(tilemap)

    hero = Hero.new
    hero.position = [200, 200]
    add(hero)

    on_touch_begin do |event|
      inner_left = 200
      inner_right = screen_width - 200
      inner_top = screen_height - 200
      inner_bottom = 200
      within_left_boundary = event.location.x > inner_left
      within_right_boundary = event.location.x < inner_right
      within_bottom_boundary = event.location.y > inner_bottom
      within_top_boundary = event.location.y < inner_top
      total_duration = hero.time_to_walk_to(event.location)
      if within_left_boundary && within_right_boundary && within_bottom_boundary && within_top_boundary
        hero.walk_to(event.location)
      else
        # walk hero to boundary
        hero.flipped_horizontally = hero.moved_left?(event.location)
        new_move_location_x = if event.location.x <= inner_left
                                inner_left
                              elsif event.location.x >= inner_right
                                inner_right
                              else
                                event.location.x
                              end
        new_move_location_y = if event.location.y <= inner_bottom
                                inner_bottom
                              elsif event.location.y >= inner_top
                                inner_top
                              else
                                event.location.y
                              end
        new_move_location = [new_move_location_x, new_move_location_y]
        hero.move_to(new_move_location, hero.time_to_walk_to(new_move_location))
        hero.run_walk_animation(total_duration)
        # continue walk animation after reaching boundary
        # animate moving map once we've reached the boundary
        if !within_left_boundary
          # move the map to the right, once we reach the boundary
          new_map_x = new_move_location_x - event.location.x
        elsif !within_right_boundary
          # move the map to the left, once we reach the boundary
          new_map_x = event.location.x - new_move_location_x
        else
          new_map_x = tilemap.position.x
        end
        if !within_top_boundary
          # move the map down, once we reach the boundary
          new_map_y = new_move_location_y - event.location.y
        elsif !within_bottom_boundary
          # move the map up, once we reach the boundary
          new_map_y = event.location.y - new_move_location_y
        else
          new_map_y = tilemap.position.y
        end
        # how long will it take until we reach the boundary?
        time_to_boundary = hero.time_to_walk_to(new_move_location)
        tilemap.run_action(MG::DelayTime.new(time_to_boundary)) do
          map_move_duration = total_duration - time_to_boundary
          move_action = MG::MoveTo.new([new_map_x, new_map_y], map_move_duration)
          tilemap.run_action(move_action)
        end
      end
    end
  end
end
