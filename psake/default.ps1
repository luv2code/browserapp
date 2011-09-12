properties {
	$base_dir  = resolve-path ..
	#$lib_dir = "$base_dir\SharedLibs"
	#$buildartifacts_dir = "$build_dir\" 
	#$sln_file = "$base_dir\Rhino.Mocks-vs2008.sln" 
	$version = "0.0.0.0"
	$build_dir = ("$base_dir\build\v" + $version)
	$webserver_port = 34535
	#$tools_dir = "$base_dir\Tools"
	#$release_dir = "$base_dir\Release"
}

task default -depends Debug 
task DisplayVersion -Description "Displays the application version" { 
  echo ("version is " + $version)
}

task Test -depends DisplayVersion, GetVendorFiles -Description "Runs the tests in the test/spec folder" {
	..\vendor\node $base_dir\test\jessie.js $base_dir\test\spec\ -f nested
}

task Build -depends DisplayVersion, GetVendorFiles, Test -Description "Minifies and combines javascript and css" {
	if ((Test-Path $build_dir -pathType container) -ne $True)
	{
		New-Item $build_dir -type directory
	}
	if ((Test-Path $base_dir\build\temp -pathType container) -ne $True)
	{
		New-Item $base_dir\build\temp -type directory
	}
	..\vendor\node ..\vendor\r.js -o app.build.js
	Copy-Item $base_dir\build\temp\* -destination $build_dir -recurse
}

task Run -depends DisplayVersion, DisplayVersion, Build -Description "Starts a browser with the built version of the app" {
	start ../vendor/node "../psake/server.js $build_dir $webserver_port"
	start http://localhost:$webserver_port/index.html
}

task Debug -depends DisplayVersion, GetVendorFiles -Description "Starts a browser with the unbuilt version of the app" {
	start ../vendor/node "../psake/server.js $base_dir\src $webserver_port"
	start http://localhost:$webserver_port/index.html
}

task GetVendorFiles -Description "Downloads all the dependencies for building and testing" {
	Import-Module ./Get-WebFile.ps1
	# Create directory if does not exist
	if ((Test-Path ..\vendor\ -pathType container) -ne $True)
	{
		New-Item ..\vendor\ -type directory
		cd ..\vendor
		Get-WebFile http://requirejs.org/docs/release/0.26.0/r.js ..\vendor\
		Get-WebFile http://nodejs.org/dist/v0.5.6/node.exe ..\vendor\
		cd ..\psake
	}
}

task ? -Description "Helper to display task info" {
	Write-Documentation
}
task help -depends ? -Description "alias to the ? task" { }