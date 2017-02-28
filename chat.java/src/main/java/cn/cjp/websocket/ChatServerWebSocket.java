package cn.cjp.websocket;

import java.io.IOException;
import java.security.Principal;
import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.CloseReason;
import javax.websocket.EncodeException;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

/**
 * socket 实例
 * 
 * @author Jinpeng Cui
 *
 */
@ServerEndpoint(value = "/chat", configurator = Channels.WebSocketConfigurator.class)
public class ChatServerWebSocket {
	/**
	 * Session set.
	 */
	public static final Set<Session> SESSIONS = Collections.newSetFromMap(new ConcurrentHashMap<>());

	public static final String USERNAME = "username";

	public ChatServerWebSocket() {
		System.out.println("..." + this.getClass());
	}

	@OnClose
	public void onClose(final Session session, final CloseReason closeReason) {
		removeSession(session);
	}

	@OnError
	public void onError(final Session session, final Throwable error) {
		removeSession(session);
	}

	@OnOpen
	public void onConnect(final Session session, final EndpointConfig conf) {
		SESSIONS.add(session);
		System.out.println(conf.getUserProperties());
		Principal principal = session.getUserPrincipal();
		System.out.println(principal);
		// session.getUserProperties().put(USERNAME, "");
	}

	@OnMessage
	public void onMessage(final String message, final Session client) throws IOException, EncodeException {
		System.out.println("rec: " + message);
		sendAll(message);
	}

	private void sendAll(String messages) throws IOException, EncodeException {

		for (final Session session : SESSIONS) {
			if (session.isOpen()) {
				session.getAsyncRemote().sendText(messages);
			}
		}
	}

	private void removeSession(final Session session) {
		SESSIONS.remove(session);
	}

}
