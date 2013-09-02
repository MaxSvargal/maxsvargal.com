var portfolioItems;

portfolioItems = (function() {
  function portfolioItems(projects) {
    this.projects = projects;
    if (typeof this.projects === 'undefined' || this.projects !== 'array') {
      'You should pass input data of projects';
    }
    this.item_height = 300;
    this.createNode();
    this.makeImages();
    this.scrollController();
  }

  portfolioItems.prototype.createNode = function() {
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

  portfolioItems.prototype.makeImages = function() {
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

  portfolioItems.prototype.drawCanvas = function(name, img, offset) {
    var context, grd, src;
    src = document.getElementById("prtf_" + name);
    src.height = this.item_height;
    context = src.getContext('2d');
    context.scale(1, offset);
    context.drawImage(img, 0, 0);
    grd = context.createLinearGradient(0, 0, 0, this.item_height);
    grd.addColorStop(0, "transparent");
    grd.addColorStop(0.5, "rgba(255, 253, 241, " + (1 - offset) + ")");
    grd.addColorStop(0.5, "rgba(0, 0, 0, " + (1 - offset) + ")");
    grd.addColorStop(1, "rgba(0, 0, 0, " + (1 - offset) + ")");
    context.fillStyle = grd;
    return context.fillRect(0, 0, src.width, this.item_height);
  };

  portfolioItems.prototype.scrollController = function() {
    var _this = this;
    this.start_point = 2000 - window.innerHeight + 60;
    return window.onscroll = function(event) {
      var data, end, i, name, offset, p_offset, start, _ref, _results;
      window.scroll = null;
      event.preventDefault();
      p_offset = window.pageYOffset || document.body.scrollTop;
      if (p_offset >= _this.start_point) {
        i = 0;
        _ref = _this.projects;
        _results = [];
        for (name in _ref) {
          data = _ref[name];
          start = _this.start_point + _this.item_height * i;
          end = start + _this.item_height;
          if (p_offset >= start && p_offset <= end) {
            offset = (p_offset - start) / _this.item_height;
            _this.drawCanvas(name, _this.projects[name].img, offset);
          }
          if (p_offset > end && p_offset < end + 50) {
            _this.drawCanvas(name, _this.projects[name].img, 1);
          }
          _results.push(i++);
        }
        return _results;
      }
    };
  };

  return portfolioItems;

})();
