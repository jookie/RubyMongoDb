
angular.module('productApp',['ui.router','ngResource','productApp.controllers','productApp.services']);

angular.module('productApp').config(function($stateProvider,$httpProvider){
    $stateProvider.state('products',{
        url:'/products',
        templateUrl:'partials/products.html',
        controller:'ProductListController'
    }).state('viewProduct',{
       url:'/products/:id/view',
       templateUrl:'partials/product-view.html',
       controller:'ProductViewController'
    }).state('newProduct',{
        url:'/products/new',
        templateUrl:'partials/product-add.html',
        controller:'ProductCreateController'
    }).state('editProduct',{
        url:'/products/:id/edit',
        templateUrl:'partials/product-edit.html',
        controller:'ProductEditController'
    });
}).run(function($state){
   $state.go('products');
});