defmodule CivilCode.Entity do
  @moduledoc """
  ## Life cycle or operational states

  Determining the current state is done via a predicate:

  ```elixir

  # good

  Order.completed?(order)

  # bad

  order.state == "completed"
  ```
  """

  defmacro __using__(_) do
  end
end
