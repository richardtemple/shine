var app = angular.module(
  'customers',
  [
    'ngRoute',
    'ngResource',
    'templates'
  ]
);

app.config([
  "$routeProvider",
  function($routeProvider) {
    // configure routes here
    $routeProvider.when("/", {
      controller: "CustomerSearchController",
      templateUrl: "customer_search.html"
    }).when("/:id", {
      controller: "CustomerDetailController",
      templateUrl: "customer_detail.html"
    });
  }
]);

app.controller("CustomerSearchController", [
          "$scope","$http", "$location",
  function($scope, $http, $location) {

    var page = 0;

    $scope.customers = [];
    $scope.search = function(searchTerm) {
      $scope.loading = true;
      if (searchTerm.length < 3) {
        return;
      }
      $http.get("/customers.json",
                { "params": { "keywords": searchTerm, "page": page } }
      ).success(
        function(data,status,headers,config) {
          $scope.customers = data;
          $scope.loading = false;
      }).error(
        function(data,status,headers,config) {
          $scope.loading = false;
          alert("There was a problem: " + status);
        });
    }

    $scope.previousPage = function() {
      if (page > 0) {
        page = page - 1;
        $scope.search($scope.keywords);
      }
    }

    $scope.nextPage = function() {
      page = page + 1;
      $scope.search($scope.keywords);
    }

    $scope.viewDetails = function(customer) {
      $location.path("/" + customer.id);
    }
  }
]);

app.controller("CustomerDetailController", [
          "$scope","$routeParams","$resource",
  function($scope , $routeParams,  $resource) {

    // Make the Ajax call and set $scope.customer...

    $scope.customerId = $routeParams.id;
    var Customer = $resource('/customers/:customerId.json');
    $scope.customer = Customer.get({ "customerId": $scope.customerId});
    //alert("Ajax Call Initiated!");
    // $http.get(
    //   "/customers/" + customerId + ".json"
    // ).then(function(response) {
    //     $scope.customer = response.data;
    //   },function(response) {
    //     alert("There was a problem: " + response.status);
    //   }
    // );
  }
]);

app.controller("CustomerCreditCardController", [
          "$scope","$resource",
  function($scope,  $resource) {
    var CreditCardInfo = $resource('/fake_billing.json')
    $scope.setCardholderId = function(cardholderId){
      $scope.creditCard = CreditCardInfo.get(
        { "cardholder_id": cardholderId}
      )
    }
  }
]);
