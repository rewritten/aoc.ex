defmodule Cache do
  def fetch(key, value_fn \\ fn -> nil end) do
    case Process.get({:__cache__, key}, :__cache_key_not_found__) do
      :__cache_key_not_found__ -> tap(value_fn.(), &Process.put({:__cache__, key}, &1))
      value -> value
    end
  end
end
