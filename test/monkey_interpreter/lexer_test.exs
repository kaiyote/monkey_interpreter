defmodule MonkeyInterpreter.LexerTest do
  use ExUnit.Case, async: true

  alias MonkeyInterpreter.{Lexer, Token}

  doctest Lexer, import: true

  describe "lexer" do
    test "can generate the proper list of tokens", context do
      tokens = cycle_lexer_to_eof context[:short_lexer]
      expected_tokens = [
        %Token{type: :assign, value: "="},
        %Token{type: :plus, value: "+"},
        %Token{type: :lparen, value: "("},
        %Token{type: :rparen, value: ")"},
        %Token{type: :lbrace, value: "{"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :comma, value: ","},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :eof, value: nil}
      ]

      assert length(tokens) == length(expected_tokens)
      for {actual, expected} <- Enum.zip(tokens, expected_tokens), do: assert actual == expected
    end
  end

  setup do
    [short_lexer: Lexer.make_lexer "=+(){},;"]
  end

  defp cycle_lexer_to_eof(lexer, tokens \\ [])
  defp cycle_lexer_to_eof(lexer, []) do
    {lexer, tok} = Lexer.next_token lexer
    cycle_lexer_to_eof lexer, [tok]
  end
  defp cycle_lexer_to_eof(%{ch: nil} = lexer, tokens) do
    {_, tok} = Lexer.next_token lexer
    Enum.reverse [tok | tokens]
  end
  defp cycle_lexer_to_eof(lexer, tokens) do
    {lexer, tok} = Lexer.next_token lexer
    cycle_lexer_to_eof lexer, [tok | tokens]
  end
end
