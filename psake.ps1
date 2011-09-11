#just an alias for invoking psake.
#type :
#	./psake - the default task is "debug" which launches the web browser and loads the app.
#	./psake build - minifies the css and javascript and combines the files.
#	./psake test - runs tests against the raw code.
#	./psake run - tests, builds, and opens the browser to the production release version.
#	./psake GetVendorFiles - downloads the vendor libraries necessary to build and run the app.
param($params)
Invoke-Psake psake/default.ps1 $params