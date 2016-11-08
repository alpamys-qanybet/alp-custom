angular.module('alpCustom').directive "selectOption", [()->
	restrict: "E"
	replace: true
	transclude: true
	templateUrl: (elm, attrs)->
		attrs.templateUrl or '../bower_components/alp-custom/src/dist/select-option/select-option.html'
		# attrs.templateUrl or 'scripts/directives/select-option/select-option.html'

	scope:
		'model': '='
		'list': '='
	
	controller: ["$scope", "$element", ($scope, $element)->
	]
		
	link: (scope, elm, attrs)->

	compile: (cElement, cAttributes, transclude)->	
		pre: (scope, element, attrs)->
			# scope.expression = 'item as item.name for item in swOptions'
			scope.expression = attrs.swOptions
		,
		post: (scope, element, attrs)->
]