module Vimrunner
  class Client
    def current_window_number
      echo('winnr()').to_i
    end

    def number_of_lines
      echo("line('$')").to_i
    end

    def window_content
      lines = echo("getline(1, '$')")
      echo(%.join(#{ lines }, "\n").)
    end

    def switch_to_window_by_number(number)
      command("execute '#{ number }wincmd w'")
    end

    def switch_to_window(name)
      window_number = echo("bufwinnr('#{ name }')")
      switch_to_window_by_number(window_number)
    end

    def first_visible_line_number
      echo("line('w0')").to_i
    end

    def current_window_name
      echo("expand('%')")
    end
  end
end
