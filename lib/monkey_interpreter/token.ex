defmodule MonkeyInterpreter.Token do
  @moduledoc "The `Token` struct for the `Lexer`"

  @typedoc "The valid `Token` types"
  @type token_type :: :illegal | :eof | :ident | :int | :assign | :plus | :comma | :semicolon |
                      :lparen | :rparen | :lbrace | :rbrace | :function | :let | :minus | :bang |
                      :asterisk | :slash | :gt | :lt | :if | :true | :false | :else | :return |
                      :eq | :not_eq

  @typedoc "The `Token` struct"
  @type t :: %__MODULE__{
    type: token_type,
    value: String.t | nil
  }

  defstruct type: :illegal, value: nil

  @spec char_to_type(String.t) :: token_type
  def char_to_type(";"), do: :semicolon
  def char_to_type(","), do: :comma
  def char_to_type("("), do: :lparen
  def char_to_type(")"), do: :rparen
  def char_to_type("{"), do: :lbrace
  def char_to_type("}"), do: :rbrace
  def char_to_type("+"), do: :plus
  def char_to_type("-"), do: :minus
  def char_to_type("*"), do: :asterisk
  def char_to_type("/"), do: :slash
  def char_to_type("<"), do: :lt
  def char_to_type(">"), do: :gt
  def char_to_type("="), do: :assign
  def char_to_type("!"), do: :bang
end
