module DI
  module COMP
    module PANEL
      
      def create_panel_by_face width, height, depth
        #puts "Create Panel : #{width} : #{height} : #{depth}"
        
        pt1 = ORIGIN
        pt2 = [width, 0, 0]
        pt3 = [width, depth, 0]
        pt4 = [0, depth, 0]

        entities = Sketchup.active_model.entities
        pre_ents = entities.to_a
        panel_face = entities.add_face([pt1, pt2, pt3, pt4]) 
        panel_face.pushpull(-height)
        post_ents = entities.to_a
        
        panel_group = entities.add_group(post_ents - pre_ents)
        panel_comp = panel_group.to_component
      end

      def create_panel_by_cube width, height, depth
        cube_file_path = File.join(DI_ROOT_PATH, 'assets/dynamic_components/dynamic_cube.skp')
        unless File.exists?(cube_file_path)
          puts "Dynamic cube file not found"
          return false
        end
        cube_def  = Sketchup.active_model.definitions.load(cube_file_path)
        dict_name = 'dynamic_attributes'

        width=width/10.mm;height=height/10.mm;depth=depth/10.mm
        
        cube_def.entities[0].set_attribute dict_name, '_lenx_formula', ('%s')%[width]
        cube_def.entities[0].set_attribute dict_name, '_leny_formula', ('%s')%[depth]
			  cube_def.entities[0].set_attribute dict_name, '_lenz_formula', ('%s')%[height]
        
        dcs = $dc_observers.get_latest_class
        dcs.redraw_with_undo(cube_def.entities[0])
        panel_comp = Sketchup.active_model.entities.add_instance(cube_def, ORIGIN)
        panel_comp.make_unique
        panel_comp
      end

      def get_panel side, inputs
        #puts "Get Panel : #{side} #{inputs}"
        pthick = inputs[:panel_thickness]
        pwidth = inputs[:width]
        pheight = inputs[:height]
        pdepth = inputs[:depth]
        unless pwidth || pheight || pdepth ||
            pwidth > 1 || pheight > 1 || pdepth > 1
          puts "Panel cannot be created"
          return nil
        end
        skirting_height = inputs[:skirting] ? 100.mm : 0.mm

        case side
        when 'left'
          width = pthick
          height = pheight
          depth = pdepth
          position = ORIGIN
        when 'right'
          width = pthick
          height = pheight
          depth = pdepth
          position = [pwidth-pthick, 0 ,0]
        when 'top'
          width = pwidth - 2*pthick
          height = pthick
          depth = pdepth
          position = [pthick, 0, pheight - pthick ]
        when 'bottom'
          width = pwidth - 2*pthick
          height = pthick
          depth = pdepth
          position = [pthick, 0, 0+skirting_height]
        when 'back'
          width = pwidth - 2*pthick
          height = pheight - 2*pthick - skirting_height
          depth = pthick
          position = [pthick, (pdepth-pthick), pthick+skirting_height]
        when 'shelf'
          width = pwidth - 2*pthick
          height = pthick
          depth = pdepth
          position = [pthick, 0, 0]
        end
        panel = create_panel_by_cube width, height, depth
        
        panel.transform!(Geom::Transformation.new(position))


      end
    end
  end
end