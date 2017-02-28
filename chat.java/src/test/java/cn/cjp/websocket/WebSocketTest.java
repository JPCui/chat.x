package cn.cjp.websocket;

import java.net.URI;
import java.util.concurrent.TimeUnit;

import javax.websocket.ClientEndpoint;

import org.apache.log4j.Logger;
import org.eclipse.jetty.websocket.client.ClientUpgradeRequest;
import org.eclipse.jetty.websocket.client.WebSocketClient;

@ClientEndpoint
public class WebSocketTest {

	static Logger logger = Logger.getLogger(WebSocketTest.class);

	public static void main(String[] args) throws Exception {
		URI echoUri = new URI("ws://local/chat.java/chat");
		WebSocketClient client = new WebSocketClient();
		client.start();

		System.out.println(client.getState());

		SimpleEchoSocket socket = new SimpleEchoSocket();
		ClientUpgradeRequest request = new ClientUpgradeRequest();
		client.connect(socket, echoUri, request);
		System.out.printf("Connecting to : %s%n", echoUri);

		// wait for closed socket connection.
		socket.awaitClose(5, TimeUnit.SECONDS);

		Thread.sleep(3000L);

		logger.info("end.");
		client.stop();

	}

}
