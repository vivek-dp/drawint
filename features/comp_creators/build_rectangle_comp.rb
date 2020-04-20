module DI
  module COMP
    module BuildRect
      extend PANEL

      def self.set_panel_attributes panel_name, input_h
        #puts "set_panel_attributes : #{panel_name}"
        comp = input_h['comp']
        case panel_name
        when 'left_panel'
          sides = {'external' => ['left', 'top', 'front', 'bottom'], 'internal'=>['right', 'back']}
        when 'right_panel'
          sides = {'external' => ['right', 'top', 'front', 'bottom'], 'internal'=>['left', 'back']}
        when 'top_panel'
          sides = {'external' => ['left', 'top', 'front', 'right'], 'internal'=>['bottom', 'back']}
        when 'bottom_panel'
          sides = {'external' => ['left', 'bottom', 'front', 'right'], 'internal'=>['top', 'back']}
        when 'back_panel'
          sides = {'internal' => ['left', 'bottom', 'front', 'right', 'top', 'back'], 'external'=>[]}
        end

        panel_comp = comp.definition.entities[0]
        panel_comp.definition.entities.each{|ent|
          side_name = ent.get_attribute('dyn_face_atts', 'side')
          visibility =  sides['external'].include?(side_name) ? 'external' : 'internal'
          ent.set_attribute('dyn_face_atts', 'visibility', visibility)
        }
        comp.definition.name = panel_name
      end

      def self.set_comp_attributes input_json
        input_json.each_pair { |name, comp_h|
          next unless comp_h['comp']
          case name
          when /panel\z/
            set_panel_attributes name, comp_h
          end
        }
      end

      def self.create_comp params
        puts "BuildRect : #{params}"

        model=Sketchup.active_model
        comp_ents = []

        #-------------  External panels --------------
        left_panel = get_panel 'left', params  
        model.active_view.refresh
        UI.refresh_inspectors()
        top_panel = get_panel 'top', params
        model.active_view.refresh
        UI.refresh_inspectors()
        bottom_panel = get_panel 'bottom', params
        model.active_view.refresh
        UI.refresh_inspectors()
        right_panel = get_panel 'right', params
        model.active_view.refresh
        UI.refresh_inspectors()
        back_panel = get_panel 'back', params
        model.active_view.refresh
        UI.refresh_inspectors()

        #-------------- Shelves -----------------------
        if params[:equal_shelves]
          panel_thickness = params[:panel_thickness]
          shelf_count = params[:shelf_count]
          skirting_height = params[:skirting] ? 100.mm : 0.mm
          internal_height = params[:height] - skirting_height - 2*panel_thickness
          
          inter_shelf_distance = (internal_height - (shelf_count-1)*panel_thickness)/shelf_count
          (1..shelf_count-1).each{ |index|
            shelf_panel = get_panel 'shelf', params
            shelf_position = [0, 0, skirting_height + (index*(panel_thickness+inter_shelf_distance))]
            shelf_panel.transform!(Geom::Transformation.new(shelf_position))
            comp_ents << shelf_panel
            model.active_view.refresh
            UI.refresh_inspectors()
          }
        end


        comp_json = {
          'left_panel' =>{'comp'=>left_panel}, 
          'top_panel' =>{'comp'=>top_panel},
          'bottom_panel' =>{'comp'=>bottom_panel},
          'right_panel' =>{'comp'=>right_panel},
          'back_panel' =>{'comp'=>back_panel},
        }

        set_comp_attributes comp_json

        
        comp_json.each_pair { |comp_name, comp_h|
          comp_ent = comp_h['comp'] 
          comp_ents << comp_ent if comp_ent
        }
        comp_group = Sketchup.active_model.entities.add_group(comp_ents)
        comp_group.definition.name = params[:comp_name]
        comp_group.name = params[:comp_name]
      end
    end
  end
end