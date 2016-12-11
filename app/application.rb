class Application < MG::Application
  def start
    director = MG::Director.shared
    # director.show_stats = true # Display frames per second stats
    director.run(ExamplesList.new)
  end
end
