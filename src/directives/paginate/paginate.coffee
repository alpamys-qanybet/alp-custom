angular.module('alpCustom').directive "paginate", ['LIB_URL', (LIB_URL)->
	restrict: "E"
	replace: true
	templateUrl: (elm, attrs)->
		if attrs.template
			LIB_URL + 'directives/paginate/paginate-'+attrs.template+'.html'
		else
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
		# run passed 'page' function on execution of 'process'
		scope.process = (index)->
			# do not rerender if current or exceeded list range index requested
			if scope.index == index or index < 0 or index >= scope.list.length
				return

			scope.index = index
			return
	]

	compile: (cElement, cAttributes, transclude)->	
		# console.log 'compile'

		# default values
		defaultValues =
			index: 0
			limit: 10
			range: 10
		
		# set default index if not assigned
		if not cAttributes.index
			cAttributes.index = '' + defaultValues.index
	
		# set default limit if not assigned
		if not cAttributes.limit
			cAttributes.limit = '' + defaultValues.limit
		
		showLimit = false

		# set limits if limits assigned and not empty
		if cAttributes.limits
			limits = JSON.parse cAttributes.limits
			if not _.isEmpty limits
				# set default limit as first
				cAttributes.limit = '' + limits[0]
				# show limits dropdown if length > 1
				showLimit = limits.length > 1
		
		# set default range if not assigned
		if not cAttributes.range
			cAttributes.range = '' + defaultValues.range
		
		pre: (scope, elm, attrs)->
			# console.log 'pre'
		,
		post: (scope, elm, attrs)->
			# console.log 'post'
			# assign scope.showLimit on post-link as scope is available
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
				return
			
			# watchers
			onInit =
				count: true
				index: true
				limit: true

			# watcher of count(total elements count) after each data come 
			scope.$watch 'count', ->
				# do not trigger watcher on init
				if onInit.count
					onInit.count = false
					return

				# render page buttons
				loadButtons()
				return

			# watchers of index and limit change by user on paginate template
			scope.$watch 'index', ->
				# do not trigger watcher on init
				if onInit.index
					onInit.index = false
					return
	
				# request for data specified to index
				scope.page({index:scope.index, limit:scope.limit})
				
				# render page buttons
				loadButtons()
				return

			scope.$watch 'limit', ->
				# do not trigger watcher on init
				if onInit.limit
					onInit.limit = false
					return

				# on limit change at the beginning
				if scope.index == 0
					scope.page({index:scope.index, limit:scope.limit})
				else # on limit change go to beginning
					scope.index = 0
				
				# render page buttons
				loadButtons()
				return

			# request for first data
			scope.page({index:scope.index, limit:scope.limit})
			return
]