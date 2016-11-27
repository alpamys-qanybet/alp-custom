angular.module('alpCustom').directive "breadcrumbs", ['LIB_URL', (LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		if attrs.template
			LIB_URL + 'directives/breadcrumbs/breadcrumbs-'+attrs.template+'.html'
		else
			attrs.templateUrl or LIB_URL + 'directives/breadcrumbs/breadcrumbs.html'
	scope:
		fetch: '&'
		list: '='
		root: '='

	controller: ["$scope", "$element", ($scope, $element)->
		init = ->
			$scope.list = []
			
			if $scope.root
				$scope.root.id = 'root'
				$scope.list.push $scope.root
			else
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
	
	link: (scope, elm, attrs)->
		if attrs.contentUrl
			scope.contentUrl = attrs.contentUrl
		return
]

angular.module('alpCustom').directive "breadcrumbsItem", ['$templateRequest', '$sce', '$compile', 'LIB_URL', ($templateRequest, $sce, $compile, LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		if attrs.template
			LIB_URL + 'directives/breadcrumbs/breadcrumbs-item-'+attrs.template+'.html'
		else
			attrs.itemTemplateUrl or LIB_URL + 'directives/breadcrumbs/breadcrumbs-item.html'
	scope:
		item: '='
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
			return
]