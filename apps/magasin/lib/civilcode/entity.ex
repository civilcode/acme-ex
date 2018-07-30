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

  defstruct [:type, :state, :events]

  defmacro __using__(_) do
  end

  def new(module, attrs \\ []) do
    struct(__MODULE__, type: module, state: struct(Module.concat(module, State), attrs))
  end

  def build(module, state) do
    struct(__MODULE__, type: module, state: state)
  end

  def get_changes(%{state: %Ecto.Changeset{} = changeset}) do
    changeset
  end

  def get_changes(entity) do
    Ecto.Changeset.change(entity.state)
  end

  def get_state(%{state: %Ecto.Changeset{}} = entity) do
    Ecto.Changeset.apply_changes(entity.state)
  end

  def get_state(entity) do
    entity.state
  end

  def apply_event(entity, func) do
    state = get_state(entity)

    case func.(state) do
      {:error, violation} ->
        {:error, violation}

      {:ok, event} ->
        new_state = Module.concat(entity.type, State).apply(state, event)
        new_entity = struct(__MODULE__, type: entity.type, state: new_state, events: [event])
        {:ok, new_entity}

      event ->
        new_state = Module.concat(entity.type, State).apply(state, event)
        new_entity = struct(__MODULE__, type: entity.type, state: new_state, events: [event])
        {:ok, new_entity}
    end
  end
end
