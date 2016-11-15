angular.module('alpCustom').directive "hierarchialDictionary", ['LIB_URL', (LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		attrs.templateUrl or LIB_URL + 'directives/hierarchial-dictionary/hierarchial-dictionary.html'
	scope:
		'fetch': '&'
		'componentModel': "="
	
	controller: ["$scope", "$element", ($scope, $element)->
	]
	
	link: (scope, elm, attrs)->
		scope.expression = attrs.swOptions
		scope.path = []

		select = ->
			scope.componentModel =
				selected: null
				full: []

			for node, i in scope.path
				scope.componentModel.full.push node.selected

			scope.componentModel.selected = scope.componentModel.full[scope.componentModel.full.length - 1]

		process = (data)->
			node =
				selected: null
				elements: data
			scope.path.push node

			select()

			scope.$watch ->
				node.selected
			,
				(newvalue, oldvalue)->
					if _.isNull newvalue
						return
					else
						index = 0
						for n in scope.path
							if n.selected.id == newvalue.id
								break
							index++

						scope.path = scope.path.slice(0, index+1)
						select()
						fetch newvalue.id
		
		fetch = (id)->
			if id
				scope.fetch({id: id, fn: (data)->
					if data and data.length > 0
						process data
				})
			else # root
				scope.fetch({id: null, fn: (data)->
					scope.path = []
					process data
				})

		fetch()
]