defmodule Mix.Tasks.Repl do
  @moduledoc false

  use Mix.Task

  alias MonkeyInterpreter.Util.Repl

  def run(_) do
    user = "whoami" |> System.cmd([]) |> elem(0) |> String.rstrip

    IO.puts "Hello #{user}! This is the Monkey programming language!"
    IO.puts "Feel free to type in commands"
    Repl.loop
  end
end
