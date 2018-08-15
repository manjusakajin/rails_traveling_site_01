$(document).ready(function() {
  "use strict";

  var menu = $('.menu');
  var menuActive = false;
  var header = $('.header');
  var searchActive = false;

  setHeader();

  $(window).on('resize', function() {
    setHeader();
  });

  $(document).on('scroll', function() {
    setHeader();
  });

  initMenu();
  initLightbox();
  initSearchForm();

  function setHeader() {
    if (window.innerWidth < 992) {
      if ($(window).scrollTop() > 100) {
        header.addClass('scrolled');
      } else {
        header.removeClass('scrolled');
      }
    } else {
      if ($(window).scrollTop() > 100) {
        header.addClass('scrolled');
      } else {
        header.removeClass('scrolled');
      }
    }
    if (window.innerWidth > 991 && menuActive) {
      closeMenu();
    }
  }


  function initMenu() {
    if ($('.hamburger').length && $('.menu').length) {
      var hamb = $('.hamburger');
      var close = $('.menu_close_container');

      hamb.on('click', function() {
        if (!menuActive) {
          openMenu();
        } else {
          closeMenu();
        }
      });

      close.on('click', function() {
        if (!menuActive) {
          openMenu();
        } else {
          closeMenu();
        }
      });
    }
  }

  function openMenu() {
    menu.addClass('active');
    menuActive = true;
  }

  function closeMenu() {
    menu.removeClass('active');
    menuActive = false;
  }


  function initLightbox() {
    if ($('.gallery_item').length) {
      $('.colorbox').colorbox({
        rel: 'colorbox',
        photo: true
      });
    }
  }

  function initSearchForm() {
    if ($('.search_form').length) {
      var searchForm = $('.search_form');
      var searchInput = $('.search_content_input');
      var searchButton = $('.content_search');

      searchButton.on('click', function(event) {
        event.stopPropagation();

        if (!searchActive) {
          searchForm.addClass('active');
          searchActive = true;

          $(document).one('click', function closeForm(e) {
            if ($(e.target).hasClass('search_content_input')) {
              $(document).one('click', closeForm);
            } else {
              searchForm.removeClass('active');
              searchActive = false;
            }
          });
        } else {
          searchForm.removeClass('active');
          searchActive = false;
        }
      });
    }
  }
});
