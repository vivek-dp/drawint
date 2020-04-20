require 'fileutils'
require 'find'

#Constants
DI_ROOT_PATH 	= File.join(File.dirname(__FILE__))

#Module Drawint
module DrawInt
  def self.load_ruby_files
    Find.find(DI_ROOT_PATH) do |file|
      next if File.extname(file) != ".rb" || file.include?('drawint_loader.rb')
      puts "loading #{file}"
      load file
    end
  end
end

DrawInt::load_ruby_files
def rr;DrawInt::load_ruby_files;end
def dd;DITools::CustomComp_Tool::create_dialog;end