defmodule BffWeb.Helpers.FaHelper do
  use Phoenix.HTML

  @doc """
  Font Awesome helper
  """
  def fa(icon, opts \\ []) do
    class = "fa fa-#{icon} #{opts[:class]}"
    content_tag(:i, nil, class: class)
  end
end
