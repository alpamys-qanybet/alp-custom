angular.module('alpCustom').service 'hierarchialTreeService', [()->
	this.map = []

	this.exists = (name)->
		return this.map.indexOf(name) != -1

	this.put = (name)->
		this.map[name] = 
			component: null
			fn: null
			list: []
		return

	return this
]

angular.module('alpCustom').directive "hierarchialTree", ['hierarchialTreeService', 'LIB_URL', (hierarchialTreeService, LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		if attrs.template
			LIB_URL + 'directives/hierarchial-tree/hierarchial-tree-'+attrs.template+'.html'
		else
			attrs.templateUrl or LIB_URL + 'directives/hierarchial-tree/hierarchial-tree.html'
	scope:
		id: '='
		fetch: '&'
		uid: '@'
		depth: '@'
		component: '='

	controller: ["$scope", "$element", ($scope, $element)->
	]
	
	link: (scope, elm, attrs)->
		if not scope.depth
			scope.depth = 0

		if attrs.contentUrl
			scope.contentUrl = attrs.contentUrl
		
		scope.templateUrl = attrs.templateUrl
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
						return
					else
						scope.fetch({id: null, fn: fn})
						return

				scope.$watch ->
					hierarchialTreeService.map[name].component
				,
					(newvalue, oldvalue)->
						scope.component = newvalue
						return
				,
					true
		
		scope.passUidToMember = name
		
		fetch = (fn, id)->
			if id
				hierarchialTreeService.map[name].fn (data)->
					fn angular.copy data
					return
				, id
				return
			else # root
				hierarchialTreeService.map[name].fn (data)->
					fn angular.copy data
					return
				return

		if scope.id
			fetch (data)->
				scope.list = data
				hierarchialTreeService.map[name].list = hierarchialTreeService.map[name].list.concat scope.list
				return
			, scope.id
			return
		else
			fetch (data)->
				scope.list = data
				hierarchialTreeService.map[name].list = hierarchialTreeService.map[name].list.concat scope.list
				return
			return
]

angular.module('alpCustom').directive "hierarchialTreeNode", ['$templateRequest', '$sce', '$compile', 'hierarchialTreeService', 'LIB_URL', ($templateRequest, $sce, $compile, hierarchialTreeService, LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		if attrs.template
			LIB_URL + 'directives/hierarchial-tree/hierarchial-tree-node-'+attrs.template+'.html'
		else
			attrs.nodeTemplateUrl or LIB_URL + 'directives/hierarchial-tree/hierarchial-tree-node.html'
	scope:
		item: '='
		uid: '@'
	
	controller: ["$scope", "$element", (scope, elm)->
	]


	compile: (cElement, cAttributes, transclude)->
		pre: (scope, elm, attrs)->
			replace = (selector, content)->
				domElement = elm.find(selector).clone()
				domElement.html content
				domElement = $compile(domElement)(scope)
				elm.find(selector).replaceWith domElement
				return

			if attrs.contentUrl
				url = $sce.getTrustedResourceUrl attrs.contentUrl
				$templateRequest(url).then (t)->
					replace '.item-content', t
					return
				, ->
					console.error 'content url not found'
					replace '.item-content', '{{item}}'
					return
				return
			else
				replace '.item-content', '{{item}}'
				return
		,
		post: (scope, elm, attrs)->
			px = 20 * Number attrs.depth
			scope.select = ->
				for i in hierarchialTreeService.map[scope.uid].list
					i.selected = false
				scope.item.selected = true
				
				hierarchialTreeService.map[scope.uid].component = angular.copy scope.item
				return

			scope.item.indented = 
				position: 'relative'
				left: px + 'px'
			
			scope.load = ->
				nextDepth = Number(attrs.depth) + 1
				if scope.item.hasChildren
					scope.item.loaded = true
					scope.item.open = true
					
					tt = '<hierarchial-tree id="item.id" uid="{{uid}}" ng-show="item.open" depth="{{'+nextDepth+'}}"'
					
					if attrs.template
						tt += ' template="'+attrs.template+'"'
					else if attrs.templateUrl
						tt += ' template-url="'+attrs.templateUrl+'"'
					
					if attrs.contentUrl
						tt += ' content-url="'+attrs.contentUrl+'"'
					
					tt += '></hierarchial-tree>'

					el = angular.element tt
					el.append tt
					$compile(el)(scope)
					elm.append(el)
					return

			scope.expand = ->
				scope.item.open = true
				return
		
			scope.collapse = ->
				scope.item.open = false
				return
			return
]