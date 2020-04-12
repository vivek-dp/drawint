module DI
  module PolyHelper
    def self.draw_edge_rectangle edge, vector, len
      pt1 = edge.vectices[0]
      pt2 = edge.vertices[1]
    end

    def self.create_cuboidal_entity length, width, height
      defn_name = 'DI_temp_defn_' + Time.now.strftime("%T%m")

      model		  = Sketchup.active_model
      entities 	= model.entities
      defns		  = model.definitions
      comp_defn	= defns.add defn_name

      pt1 		= ORIGIN
      pt2			= ORIGIN.offset(Y_AXIS, width)
      pt3 		= pt2.offset(X_AXIS, length.to_mm)
      pt4 		= pt1.offset(X_AXIS, length.to_mm)

      wall_temp_group 	= comp_defn.entities.add_group
      wall_temp_face 		= wall_temp_group.entities.add_face(pt1, pt2, pt3, pt4)

      ent_list1 	= DI::SketchupHelper::get_current_entities
      wall_temp_face.pushpull -height
      ent_list2 	= DI::SketchupHelper::get_current_entities

      new_entities 	= ent_list2 - ent_list1

      new_entities.grep(Sketchup::Face).each { |tface|
          wall_temp_group.entities.add_face tface
      }
      comp_defn
    end

    def self.get_left_point edge, face
    end

    #Find the vector perpendicular to the edge with reference to the face
    def self.find_edge_face_vector edge, face
      return false if edge.nil? || face.nil?
      edge_vector = edge.line[1]
      perp_vector = Geom::Vector3d.new(edge_vector.y, -edge_vector.x, edge_vector.z)
      offset_pt 	= edge.bounds.center.offset(perp_vector, 2.mm)
      res = face.classify_point(offset_pt)
      return perp_vector if (res == Sketchup::Face::PointInside||res == Sketchup::Face::PointOnFace)
      return perp_vector.reverse
    end

    #Check if edge is clockwise with respect to the face
    def self.check_clockwise_edge edge, face
      edge, face = face, edge if edge.is_a?(Sketchup::Face)
      conn_vector = find_edge_face_vector(edge, face)
      dot_vector	= conn_vector * edge.line[1]
      clockwise = dot_vector.z > 0
      return clockwise
    end

    #Place a cuboidal component on the start_point
    def self.place_cuboidal_component( start_point, end_point,
      comp_width: 50.mm,
      comp_height: 2000.mm,
      at_offset: 0.mm)

      start_point = start_point.position if start_point.is_a?(Sketchup::Vertex)
      end_point   = end_point.position if end_point.is_a?(Sketchup::Vertex)
      length 		= start_point.distance(end_point).mm

      #create
      comp_defn 	= create_cuboidal_entity length, comp_width, comp_height

      #Add instance
      comp_inst        = Sketchup.active_model.entities.add_instance comp_defn, start_point

      extra = 0
      #Rotate instance
      trans_vector = start_point.vector_to(end_point)
      if trans_vector.y < 0
      trans_vector.reverse!
      extra = Math::PI
      end
      angle 	= extra + X_AXIS.angle_between(trans_vector)
      comp_inst.transform!(Geom::Transformation.rotation(start_point, Z_AXIS, angle))

      if at_offset > 0.mm
      comp_inst.transform!(Geom::Transformation.new([0,0,at_offset]))
      end

      comp_inst
      end
    end
end