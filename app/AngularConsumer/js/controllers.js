
angular.module('productApp.controllers',[]).controller('ProductListController',function($scope,$state,popupService,$window,Product){

    $scope.products=Product.query();

    $scope.deleteProduct=function(product){
        if(popupService.showPopup('Really delete this?')){
            product.$delete(function(){
                $window.location.href='';
            });
        }
    }

}).controller('ProductViewController',function($scope,$stateParams,Product){

    $scope.product=Product.get({id:$stateParams.id});

}).controller('ProductCreateController',function($scope,$state,$stateParams,Product){

    $scope.product=new Product();

    $scope.addProduct=function(){
        $scope.product.$save(function(){
            $state.go('products');
        });
    }

}).controller('ProductEditController',function($scope,$state,$stateParams,Product){

    $scope.updateProduct=function(){
        $scope.product.$update(function(){
            $state.go('products');
        });
    };

    $scope.loadProduct=function(){
        $scope.product=Product.get({id:$stateParams.id});
    };

    $scope.loadProduct();
});