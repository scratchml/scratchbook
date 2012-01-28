// Keep everything in anonymous function, called on window load.
window.addEventListener('load', function () {

  var canvas, context, canvaso, contexto;

  // The active tool instance.
  var tool;
  var tool_default = 'pencil';

  function init () {

    canvaso = document.getElementById('editor_image');
    if (!canvaso) {
      console.log('Error: I cannot find the canvas element!');
      return;
    }

    if (!canvaso.getContext) {
      alert('Error: no canvas.getContext!');
      return;
    }

    contexto = canvaso.getContext('2d');
    if (!contexto) {
      alert('Error: failed to getContext!');
      return;
    }

    // Add the temporary canvas.
    var container = canvaso.parentNode;
    canvas = document.createElement('canvas');
    if (!canvas) {
      alert('Error: I cannot create a new canvas element!');
      return;
    }

    canvas.id = 'editor_image_temp';
    canvas.width = canvaso.width;
    canvas.height = canvaso.height;
    container.appendChild(canvas);

    context = canvas.getContext('2d');

    draw_grid();

    // Get the tool select input.
    var tool_select = document.getElementById('drawing_tool');
    if (!tool_select) {
      alert('Error: failed to get the drawing_tool element!');
      return;
    }
    tool_select.addEventListener('change', ev_tool_change, false);

    // Activate the default tool.
    if (tools[tool_default]) {
      tool = new tools[tool_default]();
      tool_select.value = tool_default;
    }

    // Attach the mousedown, mousemove and mouseup event listeners.
    canvas.addEventListener('mousedown', ev_canvas, false);
    canvas.addEventListener('mousemove', ev_canvas, false);
    canvas.addEventListener('mouseup',   ev_canvas, false);
  }

  function draw_grid() {
    var grid_spacing = 20,
        x_count = 0;

    // draw vertical lines
    for(var x = 0; x < canvas.width; x += grid_spacing) {
      // every 4th, thicken
      // every 16th, double-thicken?
      context.beginPath();
      context.moveTo(x, 0);
      context.lineTo(x, canvas.height);
      if(x_count % 4 == 3) {
        context.lineWidth = 2;
      }
      else {
        context.lineWidth = 1;
      }
      context.stroke();
      context.closePath();
      x_count++;
    }

     // draw horizontal lines
    for(var y = 0; y < canvas.height; y += grid_spacing) {
      console.log("y = " + y);
      context.beginPath();
      context.moveTo(0, y);
      context.lineTo(canvas.width, y);
      context.lineWidth = 1;
      context.stroke();
      context.closePath();
    }

  }

  // The general-purpose event handler. This function just determines the mouse
  // position relative to the canvas element.
  function ev_canvas (ev) {
    // if (ev.layerX || ev.layerX == 0) { // Firefox
    //   ev._x = ev.layerX;
    //   ev._y = ev.layerY;
    // } else if (ev.offsetX || ev.offsetX == 0) { // Opera
    //   ev._x = ev.offsetX;
    //   ev._y = ev.offsetY;
    // }

    ev._x = ev.offsetX;
    ev._y = ev.offsetY;

    // Call the event handler of the tool.
    var func = tool[ev.type];
    if (func) {
      func(ev);
    }
  }

  // The event handler for any changes made to the tool selector.
  function ev_tool_change (ev) {
    if (tools[this.value]) {
      tool = new tools[this.value]();
    }
  }

  // This function draws the #editor_image_temp canvas on top of #editor_image, after which
  // #editor_image_temp is cleared. This function is called each time when the user
  // completes a drawing operation.
  function img_update () {
		contexto.drawImage(canvas, 0, 0);
		context.clearRect(0, 0, canvas.width, canvas.height);
  }

  // This object holds the implementation of each drawing tool.
  var tools = {};

  // The drawing pencil.
  tools.pencil = function () {
    var tool = this;
    this.started = false;

    // This is called when you start holding down the mouse button.
    // This starts the pencil drawing.
    this.mousedown = function (ev) {
      context.beginPath();
      context.moveTo(ev._x, ev._y);
      tool.started = true;
    };

    // This function is called every time you move the mouse. Obviously, it only
    // draws if the tool.started state is set to true (when you are holding down
    // the mouse button).
    this.mousemove = function (ev) {
      if (tool.started) {
        context.lineTo(ev._x, ev._y);
        context.stroke();
      }
    };

    // This is called when you release the mouse button.
    this.mouseup = function (ev) {
      if (tool.started) {
        tool.mousemove(ev);
        tool.started = false;
        img_update();
      }
    };
  };

  // The line tool.
  tools.line = function () {
    var tool = this;
    this.started = false;

    this.mousedown = function (ev) {
      tool.started = true;
      tool.x0 = ev._x;
      tool.y0 = ev._y;
    };

    this.mousemove = function (ev) {
      if (!tool.started) {
        return;
      }

      context.clearRect(0, 0, canvas.width, canvas.height);

      context.beginPath();
      context.moveTo(tool.x0, tool.y0);
      context.lineTo(ev._x,   ev._y);
      context.stroke();
      context.closePath();
    };

    this.mouseup = function (ev) {
      if (tool.started) {
        tool.mousemove(ev);
        tool.started = false;
        img_update();
      }
    };
  };

  init();

}, false);
