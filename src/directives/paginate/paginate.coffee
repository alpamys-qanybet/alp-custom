angular.module('alpCustom').directive "paginate", ['LIB_URL', (LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		attrs.templateUrl or LIB_URL + 'directives/paginate/paginate.html'

	scope:
		'page': '&'
		'count': '@'
		'index': '='	# optional
		'showIndex': '='	# optional
		'limit': '='	# optional
		'limits': '='	# optional
		'range': '@'	# optional
	
	controller: ["$scope", "$element", (scope, elm)->
		# console.log 'ctrl'
	]

	compile: (cElement, cAttributes, transclude)->	
		# console.log 'compile'
		defaultValues =
			index: 0
			limit: 10
			limits: [1,2,3,4,5,10,15,20,25,30,40,50,100,200,300,400,500,1000]
			range: 10
		
		if not cAttributes.index
			cAttributes.index = '' + defaultValues.index
	
		if not cAttributes.limit
			cAttributes.limit = '' + defaultValues.limit
	
		showLimit = false
		if cAttributes.limits
			limits = JSON.parse cAttributes.limits
			if _.isEmpty limits
				cAttributes.limits = JSON.stringify defaultValues.limits
			else
				cAttributes.limit = '' + limits[0]
				showLimit = limits.length > 1
		else
			cAttributes.limits = JSON.stringify defaultValues.limits

		if not cAttributes.range
			cAttributes.range = '' + defaultValues.range
		
		pre: (scope, elm, attrs)->
			# console.log 'pre'
		,
		post: (scope, elm, attrs)->
			# console.log 'post'
			scope.showLimit = showLimit
		
			# render pagination buttons
			range = Number scope.range

			loadButtons = ->
				n = Math.ceil(scope.count / scope.limit)
				scope.list = [0...n]

				begin = scope.index - range / 2

				if begin < 0
					begin = 0

				end = scope.index + range / 2

				if end > n
					end = n

				if (end - begin) < range
					end = begin + range

				scope.replist = scope.list.slice(begin, end)
			
			# rerender after retrieve count data
			onInit =
				count: true
				index: true
				limit: true

			scope.$watch 'count', ->
				if onInit.count
					onInit.count = false
					return

				loadButtons()

			scope.$watch 'index', ->
				if onInit.index
					onInit.index = false
					return

				scope.page({index:scope.index, limit:scope.limit})
				loadButtons()

			scope.$watch 'limit', ->
				if onInit.limit
					onInit.limit = false
					return

				if scope.index == 0
					scope.page({index:scope.index, limit:scope.limit})
				else
					scope.index = 0
				
				loadButtons()

			scope.page({index:scope.index, limit:scope.limit})

			# run passed 'page' function on execution of 'process'
			scope.process = (index)->
				# do not rerender if current or exceeded list range index requested
				if scope.index == index or index < 0 or index >= scope.list.length
					return

				scope.index = index
]