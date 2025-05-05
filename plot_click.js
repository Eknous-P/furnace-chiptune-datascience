function (el, x, data) {
  const logs = false;
  
  el.on('plotly_click', function(d) {
    if (logs) console.log(d);
    // very hacky but works lmao
    if (logs) let id = d.points[0].value - 1;
    if (logs) console.log(id);
    if (logs) console.log(data);
    let url = 'https://youtu.be/' + data[Math.floor(id)].id;
    window.location = url;
  })
}