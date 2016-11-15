angular.module('alpCustom', [])
.constant('LIB_URL', ( ->
	scripts = document.getElementsByTagName "script"
	scriptPath = scripts[scripts.length - 1].src
	return scriptPath.substring(0, scriptPath.lastIndexOf('/') + 1)
)())