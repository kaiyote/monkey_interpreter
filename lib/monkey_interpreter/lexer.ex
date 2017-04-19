defmodule MonkeyInterpreter.Lexer do
  @moduledoc "Takes a string and turns it into a list of `Tokens`"

  alias MonkeyInterpreter.{Lexer, Token}

  import MonkeyInterpreter.Util.Macros

  @typedoc "The `Lexer` struct"
  @type t :: %__MODULE__{
    input: String.t | nil,
    position: non_neg_integer,
    read_position: non_neg_integer,
    ch: String.t | nil,
    next_ch: String.t | nil
  }

  defstruct input: nil, position: 0, read_position: 0, ch: nil, next_ch: nil

  @doc "Constructs a lexer out of an input string"
  @spec make_lexer(String.t) :: t
  def make_lexer(input) do
    lexer = %Lexer{input: input}
    read_char lexer
  end

  @doc ~S"""
  Returns the token for the current lexeme, and an appropriately advanced lexer.

  Example

      iex> lexer = make_lexer "=;"
      iex> {lexer, _} = next_token lexer
      {%MonkeyInterpreter.Lexer{ch: ";", input: "=;", position: 1, read_position: 2}, %MonkeyInterpreter.Token{type: :assign, value: "="}}
      iex> {lexer, _} = next_token lexer
      {%MonkeyInterpreter.Lexer{ch: nil, input: "=;", position: 2, read_position: 3}, %MonkeyInterpreter.Token{type: :semicolon, value: ";"}}
      iex> {lexer, _} = next_token lexer
      {%MonkeyInterpreter.Lexer{ch: nil, input: "=;", position: 2, read_position: 3}, %MonkeyInterpreter.Token{type: :eof, value: nil}}
      iex> {_, _} = next_token lexer
      {%MonkeyInterpreter.Lexer{ch: nil, input: "=;", position: 2, read_position: 3}, %MonkeyInterpreter.Token{type: :eof, value: nil}}
  """
  @spec next_token(t) :: {t, Token.t}
  def next_token(%Lexer{ch: "=", next_ch: "="} = lex) do
    {lex |> read_char |> read_char, %Token{type: :eq, value: "=="}}
  end
  def next_token(%Lexer{ch: "!", next_ch: "="} = lex) do
    {lex |> read_char |> read_char, %Token{type: :not_eq, value: "!="}}
  end
  def next_token(%Lexer{ch: c} = lex) when is_special(c) do
    {read_char(lex), %Token{type: Token.char_to_type(c), value: c}}
  end
  def next_token(%Lexer{ch: c} = lex) when is_letter(c), do: read_identifier lex
  def next_token(%Lexer{ch: c} = lex) when is_digit(c), do: read_number lex
  def next_token(%Lexer{ch: c} = lex) when is_whitespace(c), do: lex |> read_char |> next_token
  def next_token(%Lexer{ch: nil} = lex), do: {lex, %Token{type: :eof, value: nil}}
  def next_token(%Lexer{ch: c} = lex), do: {read_char(lex), %Token{type: :illegal, value: c}}

  @spec read_char(t) :: t
  defp read_char(%Lexer{input: input, read_position: read_pos} = lex) do
    %{lex | read_position: read_pos + 1,
            position: read_pos,
            ch: String.at(input, read_pos),
            next_ch: String.at(input, read_pos + 1)}
  end

  @spec read_number(t, String.t) :: {t, Token.t}
  defp read_number(lex, num \\ "")
  defp read_number(%Lexer{ch: c} = lex, num) when is_digit(c) do
    lex |> read_char |> read_number(num <> c)
  end
  defp read_number(lex, num), do: {lex, %Token{type: :int, value: num}}

  @spec read_identifier(t, String.t) :: {t, Token.t}
  defp read_identifier(lex, ident \\ "")
  defp read_identifier(%Lexer{ch: c} = lex, ident) when is_letter(c) do
    lex |> read_char |> read_identifier(ident <> c)
  end
  defp read_identifier(lex, "let"), do: {lex, %Token{type: :let, value: "let"}}
  defp read_identifier(lex, "fn"), do: {lex, %Token{type: :function, value: "fn"}}
  defp read_identifier(lex, "true"), do: {lex, %Token{type: :true, value: "true"}}
  defp read_identifier(lex, "false"), do: {lex, %Token{type: :false, value: "false"}}
  defp read_identifier(lex, "if"), do: {lex, %Token{type: :if, value: "if"}}
  defp read_identifier(lex, "else"), do: {lex, %Token{type: :else, value: "else"}}
  defp read_identifier(lex, "return"), do: {lex, %Token{type: :return, value: "return"}}
  defp read_identifier(lex, ident), do: {lex, %Token{type: :ident, value: ident}}
end
