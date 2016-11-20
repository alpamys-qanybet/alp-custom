angular.module('alpCustom').directive "breadcrumbs", ['LIB_URL', (LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		attrs.templateUrl or LIB_URL + 'directives/breadcrumbs/breadcrumbs.html'
	scope:
		'fetch': '&'
		'list': '='
	
	controller: ["$scope", "$element", ($scope, $element)->
		init = ->
			$scope.list = []
			root = 
				id: 'root'
				name: 'Main'
				
			$scope.list.push root
			return

		init()

		$scope.process = (id)->
			if id == 'root'
				init()
				$scope.fetch()
				return
			else
				list = []
				for b in $scope.list
					list.push b
					if b.id == id
						break

				$scope.list = list
				$scope.fetch({id:id})
				return

		return
	]
]