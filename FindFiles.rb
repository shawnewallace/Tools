@projectRootPath = "PROJECT_ROOT_PATH"
@wiringContainerRootPath = "WIRING_CONTAINER_PATH"

def GetInterfacesInFile(file)
	interfaces = Array.new

	File.open(file) do |io|
		io.grep(/As<(.*)>/) do |line|
			interface = line.sub!(/.*As</, "").sub!(/>(.*)/, "")
			interfaces << interface
		end
	end

	return interfaces
end

def GetWiredInterfacesByFile(path)			
				
	interfacesByFile = Array.new(2) { Array.new(0) }
	files = Dir[path + "/**/*.cs"]

	files.each do |file|	
		if file.index("AssemblyInfo.cs") == nil && file.index("/bin/") == nil && file.index("FormsApplication") == nil && file.index("WindowsService") == nil	
			GetInterfacesInFile(file).each do |interface|
				interfacesByFile << [file.to_s, interface.to_s]
			end
		end
	end

	return interfacesByFile
end

def GetNumberOfInterfaceInstancesInProject(path)
	files = Dir[path + "/**/*.cs"]

	file.each do |file|
		
	end
end

interfacesWithFiles = GetWiredInterfacesByFile(@wiringContainerRootPath)
interfaces = Array.new

interfacesWithFiles.each do |file, interface|
	interfaces << interface
	puts file.to_s + "," + interface.to_s
end

#interfaces.sort!

#puts interfaces | interfaces

#GetWiredInterfacesByFile(@projectRootPath, interfaces)
