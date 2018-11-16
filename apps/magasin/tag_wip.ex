defmodule CivilCredo.Check.Design.TagWip do
  @moduledoc """
  Checks test tagged as WIP.
  """

  @explanation [
    check: @moduledoc,
    params: [
      regex: "Any tests tagged as WIP",
    ]
  ]
  @default_params [
    # credo:disable-for-next-line
    regex: ~r/@(tag|moduletag) :wip/,
  ]

  use Credo.Check, base_priority: :high, category: :design, exit_status: 2

  @doc false
  def run(source_file, params \\ []) do
    lines = SourceFile.lines(source_file)

    issue_meta = IssueMeta.for(source_file, params)

    line_regex = params |> Params.get(:regex, @default_params)

    Enum.reduce(lines, [], &process_line(&1, &2, line_regex, issue_meta))
  end

  defp process_line({line_no, line}, issues, line_regex, issue_meta) do
    case Regex.run(line_regex, line) do
      nil -> issues
      matches ->
        trigger = matches |> List.last
        new_issue = issue_for(issue_meta, line_no, trigger)
        [new_issue] ++ issues
    end
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue issue_meta,
      message: "This test has been tagged with WIP.",
      line_no: line_no,
      trigger: trigger
  end
end
