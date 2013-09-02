var portfolioCanvas;

portfolioCanvas = (function() {
  function portfolioCanvas(projects) {
    this.projects = projects;
    if (typeof this.projects === 'undefined' || this.projects !== 'array') {
      'You should pass input data of projects';
    }
    this.item_height = 300;
    this.createDom();
    this.makeImages();
    this.scrollController();
  }

  portfolioCanvas.prototype.createDom = function() {
    var canvas, container, data, doc_width, frag, name, _ref;
    container = document.getElementById('portfolio');
    frag = document.createDocumentFragment();
    doc_width = document.body.clientWidth;
    _ref = this.projects;
    for (name in _ref) {
      data = _ref[name];
      canvas = document.createElement('canvas');
      canvas.id = "prtf_" + name;
      canvas.width = doc_width;
      canvas.height = this.item_height;
      frag.appendChild(canvas);
    }
    return container.appendChild(frag);
  };

  portfolioCanvas.prototype.makeImages = function() {
    var data, img, name, _ref, _results,
      _this = this;
    _ref = this.projects;
    _results = [];
    for (name in _ref) {
      data = _ref[name];
      img = new Image;
      img.onload = (function(nr) {
        return function() {
          return _this.drawCanvas(nr, img, 1);
        };
      })(name);
      img.src = data.src;
      _results.push(this.projects[name].img = img);
    }
    return _results;
  };

  portfolioCanvas.prototype.drawCanvas = function(name, img, offset) {
    var context, grd, src;
    src = document.getElementById("prtf_" + name);
    src.height = this.item_height;
    context = src.getContext('2d');
    context.fillStyle = 'black';
    context.fillRect(0, 0, src.width, this.item_height);
    context.scale(1, offset);
    context.drawImage(img, 0, 0);
    grd = context.createLinearGradient(0, 0, 0, this.item_height);
    grd.addColorStop(0, "rgba(255, 253, 241, " + (0.5 - offset) + ")");
    grd.addColorStop(0.5, "rgba(255, 253, 241, " + (1 - offset) + ")");
    grd.addColorStop(0.5, "rgba(0, 0, 0, " + (1 - offset) + ")");
    grd.addColorStop(1, "rgba(0, 0, 0, " + (1 - offset) + ")");
    context.fillStyle = grd;
    return context.fillRect(0, 0, src.width, this.item_height);
  };

  portfolioCanvas.prototype.scrollController = function() {
    var data, end, header, i, name, offset, p_offset, start, _ref, _results;
    header = document.getElementById("container");
    this.start_point = header.scrollHeight - window.innerHeight + 140;
    p_offset = window.pageYOffset || document.body.scrollTop;
    if (p_offset >= this.start_point) {
      i = 0;
      _ref = this.projects;
      _results = [];
      for (name in _ref) {
        data = _ref[name];
        start = this.start_point + this.item_height * i;
        end = start + this.item_height;
        if (p_offset >= start && p_offset <= end) {
          offset = (p_offset - start) / this.item_height;
          this.drawCanvas(name, this.projects[name].img, offset.toFixed(2));
        }
        if (p_offset > end && p_offset < end + 50) {
          this.drawCanvas(name, this.projects[name].img, 1);
        }
        _results.push(i++);
      }
      return _results;
    }
  };

  return portfolioCanvas;

})();
