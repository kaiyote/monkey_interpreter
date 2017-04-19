defmodule MonkeyInterpreter.Token do
  @moduledoc "The `Token` struct for the `Lexer`"

  @typedoc "The valid `Token` types"
  @type token_type :: :illegal | :eof | :ident | :int | :assign | :plus | :comma | :semicolon |
                      :lparen | :rparen | :lbrace | :rbrace | :function | :let

  @typedoc "The `Token` struct"
  @type t :: %__MODULE__{
    type: token_type,
    value: String.t | nil
  }

  defstruct type: :illegal, value: nil
end
