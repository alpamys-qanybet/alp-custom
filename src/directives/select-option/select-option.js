// Generated by CoffeeScript 1.4.0
(function() {

  angular.module('alpCustom').directive("selectOption", [
    function() {
      return {
        restrict: "E",
        replace: true,
        transclude: true,
        templateUrl: function(elm, attrs) {
          return attrs.templateUrl || '../bower_components/alp-custom/src/dist/select-option/select-option.html';
        },
        scope: {
          'model': '=',
          'list': '='
        },
        controller: function($scope, $element) {},
        link: function(scope, elm, attrs) {},
        compile: function(cElement, cAttributes, transclude) {
          return {
            pre: function(scope, element, attrs) {
              return scope.expression = attrs.swOptions;
            },
            post: function(scope, element, attrs) {}
          };
        }
      };
    }
  ]);

}).call(this);
