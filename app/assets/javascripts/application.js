// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery-3.4.1.min
//= require bootstrap.min
//= require toastr
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.pt-BR.js
//= require jquery-mask-min
//= require_tree .

$(document).ready(function($){
  $.fn.datepicker.dates['pt-BR'] = {
    days: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"],
    daysShort: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
    daysMin: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"],
    months: ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"],
    monthsShort: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"],
    today: "Hoje",
    monthsTitle: "Meses",
    clear: "Limpar",
    format: "dd/mm/yyyy"
  };

  $('.datepicker').datepicker({
    language: 'pt-BR'
  });
  $('.datepicker').mask('00/00/0000');

  $('#confirm-delete').on('shown.bs.modal', function(e) {
    $(this).find('.btn-ok-delete').attr('href', $(e.relatedTarget).data('href'));
  });

  interact('.box-pending').dropzone({
    // only accept elements matching this CSS selector
    accept: '.history',
    // Require a 75% element overlap for a drop to be possible
    overlap: 0.75,

    // listen for drop related events:

    ondropactivate: function (event) {
      // add active dropzone feedback
      event.target.classList.add('drop-active')
    },
    ondragenter: function (event) {
      var draggableElement = event.relatedTarget
      var dropzoneElement = event.target

      // feedback the possibility of a drop
      // dropzoneElement.classList.add('drop-target')
      // draggableElement.classList.add('can-drop')
      // draggableElement.textContent = 'Dragged in'
    },
    ondragleave: function (event) {
      // remove the drop feedback style
      event.target.classList.remove('drop-target')
      event.relatedTarget.classList.remove('can-drop')
      event.relatedTarget.textContent = 'Dragged out'
    },
    ondrop: function (event) {
      event.relatedTarget.textContent = 'Dropped1'
    },
    ondropdeactivate: function (event) {
      // remove active dropzone feedback
      event.target.classList.remove('drop-active')
      event.target.classList.remove('drop-target')
    }
  })

  interact('.box-started').dropzone({
    // only accept elements matching this CSS selector
    accept: '.history',
    // Require a 75% element overlap for a drop to be possible
    overlap: 0.75,

    // listen for drop related events:

    ondropactivate: function (event) {
      // add active dropzone feedback
      event.target.classList.add('drop-active')
    },
    ondragenter: function (event) {
      var draggableElement = event.relatedTarget
      var dropzoneElement = event.target

      // feedback the possibility of a drop
      // dropzoneElement.classList.add('drop-target')
      // draggableElement.classList.add('can-drop')
      // draggableElement.textContent = 'Dragged in'
    },
    ondragleave: function (event) {
      // remove the drop feedback style
      event.target.classList.remove('drop-target')
      event.relatedTarget.classList.remove('can-drop')
      event.relatedTarget.textContent = 'Dragged out'
    },
    ondrop: function (event) {
      event.relatedTarget.textContent = 'Dropped2'
    },
    ondropdeactivate: function (event) {
      // remove active dropzone feedback
      event.target.classList.remove('drop-active')
      event.target.classList.remove('drop-target')
    }
  })

  interact('.drag-drop')
    .draggable({
      inertia: true,
      modifiers: [
        interact.modifiers.restrictRect({
          restriction: 'parent',
          endOnly: true
        })
      ],
      autoScroll: true
      // dragMoveListener from the dragging demo above
      // onmove: dragMoveListener
    })
});

