<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>listening...</title>
<style type="text/css">
body {
	margin: 0 auto; text-align: center;
	background-color: black;
}
ul, li {
	list-style: none;
}
li {
	color: red;
}
</style>
</head>
<body>
	<ul id="msg-list">
	</ul>
	<div style="position: absolute; bottom: 20px;">
		<form onsubmit="return false;">
			<input type="text" name="message" value="Hello, World!" /> <input
				type="button" value="Send Web Socket Data"
				onclick="Chat.send(this.form.message.value)" />
		</form>
	</div>

	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
	<script type="text/javascript">

	var colors = ["red", "blue", "white", "green"];
	
function onShow(msg) {
	var aDom = $("<li></li>");
	aDom.addClass("aClass");
	aDom.css("color", colors[Date.now() % colors.length]);
	aDom.text(msg);
	$("#msg-list").prepend(aDom);
}
	
var Chat = {

	socket: null,
	
	init: function(url) {
		if (!window.WebSocket) {
			window.WebSocket = window.MozWebSocket;
		}
		if (window.WebSocket) {
			Chat.socket = new WebSocket(url);
			Chat.socket.onmessage = function(event) {
				console.log(event);
				onShow(event.data);
			};
			Chat.socket.onopen = function(event) {
				console.log("websocket 打开了");
				console.log(event);
			};
			Chat.socket.onclose = function(event) {
				console.log("websocket 关闭了");
				console.log(event);
			};
			Chat.socket.onerror = function(event) {
				console.error(event);
			}
		}
	},

	send: function(message) {
		if (!window.WebSocket) {
			return;
		}
		if (Chat.socket.readyState == WebSocket.OPEN) {
			Chat.socket.send(message);
		} else {
			alert("The socket is not open.");
		}
	}
};

Chat.init("ws://localhost/chat.java/chat");
</script>

</body>
</html>