defmodule MonkeyInterpreter.Util.Repl do
  @moduledoc false

  alias MonkeyInterpreter.{Lexer, Token}

  @prompt ">>"

  def loop do
    case IO.gets @prompt do
      input when input in ["\n", "\r\n"] ->
        IO.puts "Goodbye"
        :ok
      input ->
        input |> Lexer.make_lexer |> print_tokens
        loop()
    end
  end

  defp print_tokens(lexer) do
    lexer |> Lexer.next_token() |> print_token()
  end

  defp print_token({_, %Token{type: :eof}}) do
    IO.puts("%Token{type: :#{:eof}, value: nil}")
  end
  defp print_token({lexer, token}) do
    IO.puts("%Token{type: :#{token.type}, value: #{token.value}}")
    print_tokens lexer
  end
end
