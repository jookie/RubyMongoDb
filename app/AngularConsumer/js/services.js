

angular.module('productApp.services',[]).factory('Product',function($resource){
    return $resource('http://localhost:3000/products/:id',{id:'@_id'},{
        update: {
            method: 'PUT'
        }
    });
}).service('popupService',function($window){
    this.showPopup=function(message){
        return $window.confirm(message);
    }
});