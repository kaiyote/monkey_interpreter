defmodule MonkeyInterpreter.Util.Macros do
  @moduledoc "Utility Macros for MonkeyInterpreter"

  defmacro is_letter(s) do
    quote do
      unquote(s) in ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z) or
      unquote(s) in ~w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z _)
    end
  end

  defmacro is_whitespace(s) do
    quote do
      unquote(s) in [" ", "\t", "\r", "\n"]
    end
  end

  defmacro is_digit(s) do
    quote do
      unquote(s) in ~w(1 2 3 4 5 6 7 8 9 0)
    end
  end
end
