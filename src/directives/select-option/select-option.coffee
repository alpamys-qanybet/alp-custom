angular.module('alpCustom').directive "selectOption", ['LIB_URL', (LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		attrs.templateUrl or LIB_URL + 'directives/select-option/select-option.html'
	scope:
		'model': '='
		'list': '='
	
	compile: (cElement, cAttributes, transclude)->	
		pre: (scope, elm, attrs)->
			scope.expression = attrs.swOptions
			return
		,
		post: (scope, elm, attrs)->
]