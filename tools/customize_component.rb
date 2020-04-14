module DITools
  module CustomComp_Tool
    def self.create_dialog
      $customcomp_dialog = UI::HtmlDialog.new({:dialog_title=>"DrawInt - Custom", 
        :preferences_key=>"com.drawint.plugin", 
        :scrollable=>true, 
        :resizable=>false, 
        :style=>UI::HtmlDialog::STYLE_DIALOG
      })

      #file_path = File.join(DI_ROOT_PATH, 'UI/html/semantic_comp.html')
      file_path = File.join(DI_ROOT_PATH, 'UI/html/test.html')
      $customcomp_dialog.set_url(file_path)
      $customcomp_dialog.set_size(480, 530)
      $customcomp_dialog.set_position(20, 150)
      $customcomp_dialog.center
      $customcomp_dialog.show
      
      $customcomp_dialog.add_action_callback("create_custom_component"){ |dlg, param|
        puts "Inside .....#{param}"
      }
      $customcomp_dialog.add_action_callback("getroot"){ |dlg, param|
        puts "create_custom_component2...#{param}"
      }
      $customcomp_dialog.add_action_callback("getcust"){ |dlg, param|
        puts "create_custom_component3... : #{param}"
      }
    end

  end
end
#DITools::CustomComp_Tool::create_dialog