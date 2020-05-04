# Auxiliary functions
defmodule Utils do
    def get_header(header_name, headers) do
        [head | tail] = headers
        case head do
            {^header_name, header_value} -> {:ok, header_value}
            {_another_name, _} -> get_header(header_name, tail)
            _ -> {:error, "header not found"}
        end
    end

    def get_file_path(header_value) do
        result_list = Regex.run(~r/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/, header_value)
        [_, path, _] = result_list
        clear_path = Regex.replace(~r/['"]/, path, "")
        IO.inspect(result_list, label: "regular expression")
        IO.inspect(clear_path, label: "clear path")
        clear_path
    end

    def get_file_name(header_value) do
        result_list = Regex.run(~r/name[^;=\n]*=((['"]).*?\2|[^;\n]*)/, header_value)
        [_, path, _] = result_list
        clear_name = Regex.replace(~r/['"]/, path, "")
        IO.inspect(result_list, label: "regular expression")
        IO.inspect(clear_name, label: "clear name")
        clear_name
    end

    def make_zip(chunk, filepath) do
        # filepath
        # |> File.stream!
        chunk
        |> StreamGzip.gzip
        |> Stream.into(File.stream! (filepath <> ".gz"))
        |> Stream.run
    end
end
