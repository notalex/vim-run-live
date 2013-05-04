module Vimrunner
  class Client
    RESULTS_WINDOW_PREFIX = '__Run_Results_Window__'

    def switch_to_results_window
      results_window_name = RESULTS_WINDOW_PREFIX.concat(current_window_number.to_s)
      switch_to_window(results_window_name)
    end

    def run_entire_file
      echo('runner#InitializeAndRun(0)')
      # As echo returns the results, the new window is not visible. Use redraw to fix it.
      command('redraw')
    end
  end
end
