function (el, x, data) {
  el.on('plotly_click', function(d) {
    // very hacky but works lmao
    let id = d.points[0].value - 1;
    let url = 'https://youtu.be/' + data[Math.floor(id)].id;
    window.location = url;
  })
}