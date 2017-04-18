defmodule MonkeyInterpreter.Lexer do
  @moduledoc false

  alias MonkeyInterpreter.{Lexer, Token}

  @type t :: %__MODULE__{
    input: String.t | nil,
    position: non_neg_integer,
    read_position: non_neg_integer,
    ch: String.t | nil
  }

  defstruct input: nil, position: 0, read_position: 0, ch: nil

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
  def next_token(%Lexer{ch: "="} = lex), do: {read_char(lex), %Token{type: :assign, value: "="}}
  def next_token(%Lexer{ch: ";"} = lex), do: {read_char(lex), %Token{type: :semicolon, value: ";"}}
  def next_token(%Lexer{ch: "("} = lex), do: {read_char(lex), %Token{type: :lparen, value: "("}}
  def next_token(%Lexer{ch: ")"} = lex), do: {read_char(lex), %Token{type: :rparen, value: ")"}}
  def next_token(%Lexer{ch: ","} = lex), do: {read_char(lex), %Token{type: :comma, value: ","}}
  def next_token(%Lexer{ch: "+"} = lex), do: {read_char(lex), %Token{type: :plus, value: "+"}}
  def next_token(%Lexer{ch: "{"} = lex), do: {read_char(lex), %Token{type: :lbrace, value: "{"}}
  def next_token(%Lexer{ch: "}"} = lex), do: {read_char(lex), %Token{type: :rbrace, value: "}"}}
  def next_token(%Lexer{ch: nil} = lex), do: {lex, %Token{type: :eof, value: nil}}
  def next_token(%Lexer{ch: c} = lex), do: {read_char(lex), %Token{type: :illegal, value: c}}

  @spec read_char(t) :: t
  defp read_char(%Lexer{input: input, read_position: read_pos} = lexer) do
    %{lexer | read_position: read_pos + 1, position: read_pos, ch: String.at(input, read_pos)}
  end
end
