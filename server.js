//a lot of credit for this goes to psanford: https://github.com/psanford/node-mjpeg-test-server

var http = require('http'),
	qs = require('querystring');

var stream = '';

http.createServer(function(req, res) {
	if(req.method == 'GET') {
		res.writeHead(200, {
			'Content-Type': 'multipart/x-mixed-replace; boundary=streamstart',
			'Cache-Control': 'no-cache',
			'Connection': 'close',
			'Pragma': 'no-cache'
		});
		
		var timer;
		
		var loop = function() {
			res.write('--streamstart');
			res.write("Content-Type: image/jpeg\r\n");
			res.write("Content-Length: " + stream.length + "\r\n");
			res.write("\r\n");
			res.write(stream, 'binary');
			res.write("\r\n");

			timer = setTimeout(loop, 1000);
		}
		
		loop();
		
		res.connection.on('close', function() { clearTimeout(timer) });
	} else {
		var data = '';
		
		req.on('data', function(chunk) {
			data += chunk;
		});
		
		req.on('end', function() {
			stream = new Buffer(qs.parse(data).data, 'base64');
		});
		
		res.end();
	}
}).listen(8080);