// Generated by CoffeeScript 1.4.0
(function() {

  angular.module('alpCustom').directive("breadcrumbs", [
    function() {
      return {
        restrict: "E",
        replace: true,
        transclude: true,
        templateUrl: function(elm, attrs) {
          return attrs.templateUrl || '../bower_components/alp-custom/src/dist/breadcrumbs/breadcrumbs.html';
        },
        scope: {
          'fetch': '&',
          'list': '='
        },
        controller: ["$scope", "$element", function($scope, $element) {}],
        link: function(scope, elm, attrs) {
          var init;
          init = function() {
            var root;
            scope.list = [];
            root = {
              id: 'root',
              name: 'Main'
            };
            return scope.list.push(root);
          };
          init();
          return scope.process = function(id) {
            var b, list, _i, _len, _ref;
            if (id === 'root') {
              init();
              return scope.fetch();
            } else {
              list = [];
              _ref = scope.list;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                b = _ref[_i];
                list.push(b);
                if (b.id === id) {
                  break;
                }
              }
              scope.list = list;
              return scope.fetch({
                id: id
              });
            }
          };
        }
      };
    }
  ]);

}).call(this);
