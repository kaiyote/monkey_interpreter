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

      for {actual, expected} <- Enum.zip(tokens, expected_tokens), do: assert actual == expected
      assert length(tokens) == length(expected_tokens)
    end

    test "can lex a pseudo-monkey program", context do
      tokens = cycle_lexer_to_eof context[:long_lexer]
      expected_tokens = [
        %Token{type: :let, value: "let"},
        %Token{type: :ident, value: "five"},
        %Token{type: :assign, value: "="},
        %Token{type: :int, value: "5"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :let, value: "let"},
        %Token{type: :ident, value: "ten"},
        %Token{type: :assign, value: "="},
        %Token{type: :int, value: "10"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :let, value: "let"},
        %Token{type: :ident, value: "add"},
        %Token{type: :assign, value: "="},
        %Token{type: :function, value: "fn"},
        %Token{type: :lparen, value: "("},
        %Token{type: :ident, value: "x"},
        %Token{type: :comma, value: ","},
        %Token{type: :ident, value: "y"},
        %Token{type: :rparen, value: ")"},
        %Token{type: :lbrace, value: "{"},
        %Token{type: :ident, value: "x"},
        %Token{type: :plus, value: "+"},
        %Token{type: :ident, value: "y"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :let, value: "let"},
        %Token{type: :ident, value: "result"},
        %Token{type: :assign, value: "="},
        %Token{type: :ident, value: "add"},
        %Token{type: :lparen, value: "("},
        %Token{type: :ident, value: "five"},
        %Token{type: :comma, value: ","},
        %Token{type: :ident, value: "ten"},
        %Token{type: :rparen, value: ")"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :bang, value: "!"},
        %Token{type: :minus, value: "-"},
        %Token{type: :slash, value: "/"},
        %Token{type: :asterisk, value: "*"},
        %Token{type: :int, value: "5"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :int, value: "5"},
        %Token{type: :lt, value: "<"},
        %Token{type: :int, value: "10"},
        %Token{type: :gt, value: ">"},
        %Token{type: :int, value: "5"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :if, value: "if"},
        %Token{type: :lparen, value: "("},
        %Token{type: :int, value: "5"},
        %Token{type: :lt, value: "<"},
        %Token{type: :int, value: "10"},
        %Token{type: :rparen, value: ")"},
        %Token{type: :lbrace, value: "{"},
        %Token{type: :return, value: "return"},
        %Token{type: :true, value: "true"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :else, value: "else"},
        %Token{type: :lbrace, value: "{"},
        %Token{type: :return, value: "return"},
        %Token{type: :false, value: "false"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :int, value: "10"},
        %Token{type: :eq, value: "=="},
        %Token{type: :int, value: "10"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :int, value: "10"},
        %Token{type: :not_eq, value: "!="},
        %Token{type: :int, value: "9"},
        %Token{type: :semicolon, value: ";"},
        %Token{type: :eof}
      ]

      for {actual, expected} <- Enum.zip(tokens, expected_tokens), do: assert actual == expected
      assert length(tokens) == length(expected_tokens)
    end
  end

  setup do
    [short_lexer: Lexer.make_lexer("=+(){},;"),
     long_lexer: Lexer.make_lexer("let five = 5;
     let ten = 10;

     let add = fn(x, y) {
       x + y;
     };

     let result = add(five, ten);
     !-/*5;
     5 < 10 > 5;

     if (5 < 10) {
       return true;
     } else {
       return false;
     }

     10 == 10;
     10 != 9;
     ")]
  end

  defp cycle_lexer_to_eof(lexer, tokens \\ [])
  defp cycle_lexer_to_eof(_, [%Token{type: :eof} | _] = tokens), do: Enum.reverse tokens
  defp cycle_lexer_to_eof(lexer, tokens) do
    {lexer, tok} = Lexer.next_token lexer
    cycle_lexer_to_eof lexer, [tok | tokens]
  end
end
