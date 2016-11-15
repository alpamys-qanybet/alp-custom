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

		init()

		$scope.process = (id)->
			if id == 'root'
				init()
				$scope.fetch()
			else
				list = []
				for b in $scope.list
					list.push b
					if b.id == id
						break

				$scope.list = list
				$scope.fetch({id:id})
	]
	
	link: (scope, elm, attrs)->
		# $templateRequest, $sce, $compile, $templateCache
		# console.log LIB_URL
		# render = (template)->
		# 	elm.html(template).show()
		# 	$compile(elm.contents())(scope)
		# 	return

		# lookup = (url)->
		# 	if t = $templateCache.get url
		# 		render t
		# 	else
		# 		url = $sce.getTrustedResourceUrl(url)
		# 		$templateRequest(url).then (t)->
		# 			render t
		# 		, ->
		# 			console.error 'Status 404: ' + url + ' not found'

		# if attrs.templateUrl
		# 	lookup attrs.templateUrl
		# else
		# 	lookup LIB_URL + 'directives/breadcrumbs/breadcrumbs.html'
]