require 'sketchup.rb'
require 'extensions.rb'

folder_path = 'P:/drawint'

loader 			    = File.join(folder_path, 'drawint_loader.rb')
title 			    = 'Drawint Design tool'
ext 			      = SketchupExtension.new(title, loader)
ext.version 	  = '0.1.1'
ext.copyright 	= 'Drawint - 2020'
ext.creator 	  = 'Drawint Development Team'
Sketchup.register_extension(ext, true)