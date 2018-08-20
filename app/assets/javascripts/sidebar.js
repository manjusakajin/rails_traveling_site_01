$(document).ready(function () {
  $('#sidebarCollapse').on('click', function () {
      $('#sidebar').toggleClass('active');
      $(this).toggleClass('active');
  });

  $('#sidebarCollapse1').on('click', function () {
      $('#sidebar').toggleClass('active');
      $(this).toggleClass('active');
  });

  // $('#new_plant').on('submit', function(event){
  //   var address = $('#place-input').val();
  //   if (address.length < 10) {
  //     alert('Location not found!: ' + status);
  //     return false;
  //   };
  // });
});
