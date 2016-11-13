angular.module('alpCustom').service 'hierarchialTreeService', [()->
	this.map = []

	this.exists = (name)->
		return this.map.indexOf(name) != -1

	this.put = (name)->
		this.map[name] = 
			component: null
			fn: null

	return this
]

angular.module('alpCustom').directive "hierarchialTree", ['hierarchialTreeService', (hierarchialTreeService)->
	restrict: "E"
	replace: true
	template: "<ul><hierarchial-tree-node ng-repeat='c in list' item='c' uid='{{passUidToMember}}' content='{{content}}'></hierarchial-tree-node></ul>"
	scope:
		id: '='
		fetch: '&'
		uid: '@'
		component: '='

	controller: ["$scope", "$element", ($scope, $element)->
	]
	
	link: (scope, elm, attrs)->
		scope.content = attrs.content
		name = ''

		if scope.uid
			name = scope.uid
		else
			name = 'uid'+scope.$id
			if not hierarchialTreeService.exists name
				hierarchialTreeService.put name
				hierarchialTreeService.map[name].fn = (fn, id)->
					if id
						scope.fetch({id: id, fn: fn})
					else
						scope.fetch({id: null, fn: fn})

				scope.$watch ->
					hierarchialTreeService.map[name].component
				,
					(newvalue, oldvalue)->
						scope.component = newvalue
				,
					true
		
		scope.passUidToMember = name
		
		fetch = (fn, id)->
			if id
				hierarchialTreeService.map[name].fn (data)->
					fn data
				, id
			else # root
				hierarchialTreeService.map[name].fn (data)->
					fn data

		if scope.id
			fetch (data)->
				scope.list = data
			, scope.id
		else
			fetch (data)->
				scope.list = data
]

angular.module('alpCustom').directive "hierarchialTreeNode", ['$templateRequest', '$sce', '$compile', 'hierarchialTreeService', ($templateRequest, $sce, $compile, hierarchialTreeService)->
	restrict: "E"
	replace: true
	scope:
		item: '='
		uid: '@'
	
	controller: ["$scope", "$element", ($scope, $element)->
	]
	
	link: (scope, elm, attrs)->
		scope.select = ->
			hierarchialTreeService.map[scope.uid].component = angular.copy scope.item
		
		templateUrl = $sce.getTrustedResourceUrl(attrs.content)
		$templateRequest(templateUrl).then (t)->
			template = "<li ng-click='select()'> " + t + " <button ng-show='item.hasChildren && !item.loaded' ng-click='load()'>+</button><button ng-show='item.loaded && !item.open' ng-click='expand()'>+</button><button ng-show='item.loaded && item.open' ng-click='collapse()'>-</button></li>"
			elm.html(template).show()
			$compile(elm.contents())(scope)
			return
		, ->
			console.log 'error'
			template = "<li ng-click='select()'> {{item}} <button ng-show='item.hasChildren && !item.loaded' ng-click='load()'>+</button><button ng-show='item.loaded && !item.open' ng-click='expand()'>+</button><button ng-show='item.loaded && item.open' ng-click='collapse()'>-</button></li>"
			# template = '<h1>Error, template ' + attrs.content + ' failed to load!</h1>' + template
			elm.html(template).show()
			$compile(elm.contents())(scope)
			return
		
		scope.load = ->
			if scope.item.hasChildren
				scope.item.loaded = true
				scope.item.open = true
				elm.append('<hierarchial-tree id="item.id" uid="{{uid}}" ng-show="item.open" content="'+attrs.content+'"></hierarchial-tree>')
				$compile(elm.contents())(scope)
				return

		scope.expand = ->
			scope.item.open = true
	
		scope.collapse = ->
			scope.item.open = false
]