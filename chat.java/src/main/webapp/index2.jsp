<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
    <title>socket.io 聊天室例子</title>
    <meta charset="utf-8">

    <style type="text/css">
      body {
        margin: 0;
        padding: 0;
      }

      .wrapper {
        margin: 0 auto;
        width: 800px;
        word-break: break-all;
      }

    </style>
</head>
<body>
    <div class="wrapper">
         <div class="content" id="chat">
             <div id="chat_conatiner">
             </div>
         </div>
         <div class="action">
             <input id="textIpt" />
             <button class="btn btn-success" id="clear">清屏</button>
             <button class="btn btn-success" id="send">发送</button>
         </div>
    </div>
    <script type="text/javascript" src="./lib/js/socket.io.js"></script>
    <script type="text/javascript">

          var ws = io.connect('http://local/chat.java/ws');
          var sendMsg = function(msg){
              ws.emit('send.message', msg);
          }
          var addMessage = function(from, msg){
              var li = document.createElement('div');
                li.innerHTML = '<span><img alt="' + from + '"/></span>' + ' ' + msg;
              
              document.querySelector('#chat_conatiner').appendChild(li);

              // 设置内容区的滚动条到底部
              document.querySelector('#chat').scrollTop = document.querySelector('#chat').scrollHeight;

              // 并设置焦点
              document.querySelector('#textIpt').focus();

          }

          var send = function(){
              var ele_msg = document.querySelector('#textIpt');
              var msg = ele_msg.value.replace('\r\n', '').trim();
              if(!msg) return;
              sendMsg(msg);
              // 添加消息到自己的内容区
              addMessage('你', msg);
              ele_msg.value = '';
          }

          ws.on('connect', function(){
              var nickname = window.prompt('输入你的昵称!');
              ws.emit('join', nickname);
          });

          // 昵称有重复
          ws.on('nickname', function(){
              var nickname = window.prompt('昵称有重复，请重新输入!');
              ws.emit('join', nickname);
          });

          ws.on('send.message', function(from, msg){
              addMessage(from, msg);
          });

          ws.on('announcement', function(from, msg){
              addMessage(from, msg);
          });

          document.querySelector('#textIpt').addEventListener('keypress', function(event){
              if(event.which == 13){
                  send();
              }
          });
          document.querySelector('#textIpt').addEventListener('keydown', function(event){
              if(event.which == 13){
                  send();
              }
          });
          document.querySelector('#send').addEventListener('click', function(){
              send();
          });

          document.querySelector('#clear').addEventListener('click', function(){
              document.querySelector('#chat_conatiner').innerHTML = '';
          });
    </script>
</body>
</html>