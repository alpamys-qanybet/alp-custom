angular.module('alpCustom').directive "paginate", [()->
	restrict: "E"
	replace: true
	transclude: true
	templateUrl: (elm, attrs)->
		attrs.templateUrl or '../bower_components/alp-custom/src/dist/paginate/paginate.html'
	scope:
		'page': '&'
		'count': '@'
		'limit': '='
		'index': '='
		'showIndex': '='
		'showLimit': '='
		'range': '@'
	
	controller: ($scope, $element)->
		$scope.limits = [1,2,3,4,5,10,15,20,25,30,40,50,100,200,300,400,500,1000]
		# render pagination buttons
		range = $scope.range #10
		ONE_DIGIT_WIDTH = 41
		TWO_DIGIT_WIDTH = 49
		THREE_DIGIT_WIDTH = 56.36
		FOUR_DIGIT_WIDTH = 64.157

		loadButtons = ->
			n = Math.ceil($scope.count / $scope.limit)
			$scope.list = [0...n]

			if (n < 10) 
				$scope.stylewidth = n * ONE_DIGIT_WIDTH
			else if (n < 100)
				$scope.stylewidth = 9 * ONE_DIGIT_WIDTH
				$scope.stylewidth += (n - 9) * TWO_DIGIT_WIDTH
			else if (n < 1000)
				$scope.stylewidth = 9 * ONE_DIGIT_WIDTH
				$scope.stylewidth += 90 * TWO_DIGIT_WIDTH
				$scope.stylewidth += (n - 99) * THREE_DIGIT_WIDTH
			else 
				# if (n < 10000)
				$scope.stylewidth = 9 * ONE_DIGIT_WIDTH
				$scope.stylewidth += 90 * TWO_DIGIT_WIDTH
				$scope.stylewidth += 900 * THREE_DIGIT_WIDTH
				$scope.stylewidth += (n - 999) * FOUR_DIGIT_WIDTH


			begin = $scope.index - range / 2
			if begin < 0
				begin = 0

			end = $scope.index + range / 2
			if end > n
				end = n

			if (end - begin) < range
				end = begin + range

			$scope.replist = $scope.list.slice(begin, end)
		
		$scope.index = 0
		# loadButtons()

		# rerender after retrieve count data
		$scope.$watch 'count', ->
			$scope.index = 0
			loadButtons()

		$scope.$watch 'index', ->
			$scope.page({index:$scope.index})
			loadButtons()

		$scope.$watch 'limit', ->
			$scope.index = 0
			loadButtons()

	link: (scope, elm, attrs)->
		# run passed 'page' function on execution of 'process'
		scope.process = (index)->
			# do not rerender if current or exceeded list range index requested
			if scope.index == index or index < 0 or index >= scope.list.length
				return

			scope.index = index
			# scope.page({index:index})
]
    
