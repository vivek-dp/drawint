require 'singleton'
module DrawInt
  class EdgeToWall
    include Singleton
    
    #Draw wall on the larger face
    def draw_wall sel_edge, len
      faces = sel_edge.faces
      edge_vector = sel_edge.line[1]
      vertices = sel_edge.vertices

      perp_vector = Geom::Vector3d.new(edge_vector.y, -edge_vector.x, edge_vector.z)
      if faces.empty?
        DI::PolyHelper::place_cuboidal_component vertices[0], vertices[1]
      else
        largest_face = sel_edge.faces.sort{|face| face.area}.reverse[0]
        clockwise = DI::PolyHelper::check_clockwise_edge sel_edge, largest_face
        if clockwise
            pt1, pt2 = vertices[0].position, vertices[1].position
        else
            pt1, pt2 = vertices[1].position, vertices[0].position
        end
        DI::PolyHelper::place_cuboidal_component pt1, pt2
      end
    end
    
    def onLButtonDown(flags,x,y,view)
      ent = DI::ToolHelper.get_tool_pick view, x, y
      puts "onLButtonDown : #{x} : #{y} : #{ent}"
      if ent.is_a?(Sketchup::Edge)
        draw_wall ent, 100.mm
      else
        puts "Cicked is not an edge. Please click an edge to use this tool"
      end
    end
  end
end

Sketchup.active_model.select_tool(DrawInt::EdgeToWall.instance)