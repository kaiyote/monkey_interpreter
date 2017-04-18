defmodule MonkeyInterpreter.Token do
  @moduledoc false

  @type token_type :: :illegal | :eof | :ident | :int | :assign | :plus | :comma | :semicolon |
                       :lparen | :rparen | :lbrace | :rbrace | :function | :let

  @type t :: %__MODULE__{
    type: token_type,
    value: String.t
  }

  defstruct [:type, :value]
end
