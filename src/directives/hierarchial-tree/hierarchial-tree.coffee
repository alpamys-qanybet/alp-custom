angular.module('alpCustom').service 'hierarchialTreeService', [()->
	this.map = []

	this.exists = (name)->
		return this.map.indexOf(name) != -1

	this.put = (name)->
		this.map[name] = 
			component: null
			fn: null
			list: []

	return this
]

angular.module('alpCustom').directive "hierarchialTree", ['hierarchialTreeService', 'LIB_URL', (hierarchialTreeService, LIB_URL)->
	restrict: "E"
	replace: true
	template: "<ul class='tree'><hierarchial-tree-node ng-repeat='c in list' item='c' uid='{{passUidToMember}}' content='{{content}}' depth='{{depth}}'></hierarchial-tree-node></ul>"
	scope:
		id: '='
		fetch: '&'
		uid: '@'
		depth: '@'
		component: '='

	controller: ["$scope", "$element", ($scope, $element)->
	]
	
	link: (scope, elm, attrs)->
		console.log LIB_URL

		if not scope.depth
			scope.depth = 0

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
				hierarchialTreeService.map[name].list = hierarchialTreeService.map[name].list.concat scope.list
				return
			, scope.id
		else
			fetch (data)->
				scope.list = data
				hierarchialTreeService.map[name].list = hierarchialTreeService.map[name].list.concat scope.list
				return
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
		px = 20 * Number attrs.depth
		scope.select = ->
			for i in hierarchialTreeService.map[scope.uid].list
				i.selected = false
			scope.item.selected = true
			
			hierarchialTreeService.map[scope.uid].component = angular.copy scope.item

		indented = "style='position: relative; left: "+px+"px'"
		
		templateBegin = "<li ng-click='select()' ng-animate='tree-animate' class='tree-node' ng-class='{active: item.selected}'>"
		templateBegin += 	"<a>"
		templateBegin += 		"<i ng-show='!item.hasChildren' class='glyphicon glyphicon-file' "+indented+"></i>"
		templateBegin += 		"<i ng-show='item.hasChildren && !item.loaded' ng-click='load()' class='glyphicon glyphicon-plus' "+indented+"></i>"
		templateBegin += 		"<i ng-show='item.loaded && !item.open' ng-click='expand()' class='glyphicon glyphicon-plus' "+indented+"></i>"
		templateBegin += 		"<i ng-show='item.loaded && item.open' ng-click='collapse()' class='glyphicon glyphicon-minus' "+indented+"></i>"
		templateBegin += 		"<span class='tree-label' "+indented+">"
		
		templateEnd = "</span></a></li>"

		templateUrl = $sce.getTrustedResourceUrl(attrs.content)
		$templateRequest(templateUrl).then (t)->
			template = templateBegin + t + templateEnd
			elm.html(template).show()
			$compile(elm.contents())(scope)
			return
		, ->
			console.log 'error'
			template = templateBegin + "{{item}}" + templateEnd
			# template = '<h1>Error, template ' + attrs.content + ' failed to load!</h1>' + template
			elm.html(template).show()
			$compile(elm.contents())(scope)
			return
		
		scope.load = ->
			nextDepth = Number(attrs.depth) + 1
			if scope.item.hasChildren
				scope.item.loaded = true
				scope.item.open = true
				elm.append('<hierarchial-tree id="item.id" uid="{{uid}}" ng-show="item.open" content="'+attrs.content+'" depth={{'+nextDepth+'}}></hierarchial-tree>')
				$compile(elm.contents())(scope)
				return

		scope.expand = ->
			scope.item.open = true
	
		scope.collapse = ->
			scope.item.open = false
]