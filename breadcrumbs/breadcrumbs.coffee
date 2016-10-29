angular.module('alpCustom', [])

angular.module('alpCustom').directive "breadcrumbs", [()->
	restrict: "EA"
	templateUrl: ($element, $attrs)->
		$attrs.templateUrl or 'scripts/directives/breadcrumbs/breadcrumbs.html'
	scope:
		'fetch': '&'
		'list': '='
	
	controller: ($scope, $element)->
		
	link: (scope, elm, attrs)->
		init = ->
			scope.list = []
			root = 
				id: 'root'
				name: 'Main'
				
			scope.list.push root

		init()

		scope.process = (id)->
			if id == 'root'
				init()
				scope.fetch()
			else
				list = []
				for b in scope.list
					list.push b
					if b.id == id
						break

				scope.list = list
				scope.fetch({id:id})
]
