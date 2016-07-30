class Application < MG::Application
  def start
    director = MG::Director.shared
    director.run(ExamplesList.new)
  end
end
