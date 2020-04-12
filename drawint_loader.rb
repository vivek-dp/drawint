require 'fileutils'

#Constants
DI_ROOT_PATH 	= File.join(File.dirname(__FILE__))

#Module Drawint
module DrawInt
  def self.lr_files
    Dir.entries(DI_ROOT_PATH).each{|dir_name|
      dir_path = File.join(DI_ROOT_PATH, dir_name)
      Dir[dir_path+"/*.rb"].each { |file_name|
        puts "Loading : #{file_name}"
        load File.join(file_name)
      }
    }
  end
end