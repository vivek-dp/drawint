require 'fileutils'

#Constants
DI_ROOT_PATH 	= File.join(File.dirname(__FILE__))

#Module Drawint
module DrawInt
  def self.load_ruby_files
    Dir.entries(DI_ROOT_PATH).each{|dir_name|
      next if dir_name == '.' #Skip the root directory
      dir_path = File.join(DI_ROOT_PATH, dir_name)
      Dir[dir_path+"/*.rb"].each { |file_name|
        puts "Loading : #{file_name}"
        load File.join(file_name)
      }
    }
  end
end

DrawInt::load_ruby_files