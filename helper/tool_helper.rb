module DI
  module ToolHelper
    def self.get_tool_pick view, x, y
      ph = view.pick_helper
      ph.do_pick x, y
      entity = ph.best_picked
      return entity
    end
  end
end