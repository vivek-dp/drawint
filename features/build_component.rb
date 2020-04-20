module DI
  module COMP
    def self.str_to_f inp;return inp.to_f;end
    def self.str_to_f_mm inp;return inp.to_f.mm;end

    def self.convert_inputs params
      params[:width] = str_to_f_mm(params[:width])
      params[:depth] = str_to_f_mm(params[:depth])
      params[:height] = str_to_f_mm(params[:height])
      params[:panel_thickness] = str_to_f_mm(params[:panel_thickness])
      params[:shelf_count] = params[:shelf_count].to_i
      params
    end
    
    def self.build_comp params
      DI::RubyHelper::symbolize_keys_deep!(params)
      params = convert_inputs(params)

      puts "Creating Component : #{DI::PrintHelper.time_utc(4)} : #{params}"

      shape = params[:shape]
      case shape
      when 'rectangle'
        BuildRect::create_comp params
      when 'sphere'
        #build_sphere_comp params
      end #case shape

      puts "Component Created : #{DI::PrintHelper.time_utc(4)}"
    end
  end
end