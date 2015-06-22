/**
 * Created by dovy on 1/17/2015.
 */
// app/assets/javascripts/angular/controllers/users_controllers.js
var myApp = angular.module('myapplication', ['ngRoute', 'ngResource']);

myApp.factory('Users', ['$resource',function($resource){
    return $resource('/users.json', {},{
        query: { method: 'GET', isArray: true },
        create: { method: 'POST' }
    })
}]);

myApp.factory('User', ['$resource', function($resource){
    return $resource('/users/:id.json', {}, {
        show: { method: 'GET' },
        update: { method: 'PUT', params: {id: '@id'} },
        delete: { method: 'DELETE', params: {id: '@id'} }
    });
}]);

myApp.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
        $routeProvider.when('/users',{
            templateUrl: '/templates/users/index.html',
            controller: 'UserListCtr'
        });
        $routeProvider.when('/users/new', {
            templateUrl: '/templates/users/new.html',
            controller: 'UserAddCtr'
        });
        $routeProvider.when('/users/:id/edit', {
            templateUrl: '/templates/users/edit.html',
            controller: "UserUpdateCtr"
        });
        $routeProvider.otherwise({
            redirectTo: '/users'
        });
    }
]);




myApp('hello', [])
    .controller('home', function($scope, $http) {
        $http.get('/resource/').success(function(data) {
            $scope.greeting = data;
        })
    });
function Hello($scope, $http) {
    $http.get('http://rest-service.guides.spring.io/greeting').
        success(function(data) {
            $scope.greeting = data; //Model object name greeting
        });
}

myApp.controller("UserListCtr", ['$scope', '$http', '$resource', 'Users', 'User', '$location', function($scope, $http, $resource, Users, User, $location) {

    $scope.users = Users.query();

    $scope.deleteUser = function (userId) {
        if (confirm("Are you sure you want to delete this user?")){
            User.delete({ id: userId }, function(){
                $scope.users = Users.query();   // after delete user get users collection.
                $location.path('/');
            });
        }
    };
}]);

myApp.controller("UserAddCtr", ['$scope', '$resource', 'Users', '$location', function($scope, $resource, Users, $location) {
    $scope.save = function () {
        if ($scope.userForm.$valid){
            Users.create({user: $scope.user}, function(){
                $location.path('/');
            }, function(error){
                console.log(error)
            });
        }
    }
}]);

myApp.controller("UserUpdateCtr", ['$scope', '$resource', 'User', '$location', '$routeParams', function($scope, $resource, User, $location, $routeParams) {
    $scope.user = User.get({id: $routeParams.id})
    $scope.update = function(){
        if ($scope.userForm.$valid){
            User.update($scope.user,function(){
                $location.path('/');
            }, function(error) {
                console.log(error)
            });
        }
    };
}]);

