package com.zeppelin.insite.chipcard;

import java.io.StringReader;

import javax.json.Json;
import javax.json.stream.JsonParser;
import javax.smartcardio.CardException;

import org.apache.log4j.Logger;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;

import com.zeppelin.insite.chipcard.cardobserver.CardObserver;
import com.zeppelin.insite.chipcard.cardobserver.CardObserver.SendReason;

@WebSocket()
public class CardSocket
{
	private static Logger logger = Logger.getRootLogger();
	
	private Session session = null;
	private CardObserver observer = null;

	public CardSocket(CardObserver observer)
	{
		this.observer = observer;
	}

	public Session getSession()
	{
		return this.session;
	}

	@OnWebSocketMessage()
	public void onText(Session session, String message)
	{
		if (session.isOpen())
		{
			JsonParser parser = Json.createParser(new StringReader(message));
			StringBuilder sb = new StringBuilder();
			while (parser.hasNext())
			{
				JsonParser.Event event = parser.next();
				switch (event)
				{
					case VALUE_FALSE:
					case VALUE_TRUE:
					case VALUE_NULL:
						sb.append(event.toString()).append('\n');
						break;
						
					case KEY_NAME:
						sb.append(parser.getString()).append(" = ");
						break;
						
					case VALUE_NUMBER:
					case VALUE_STRING:
						sb.append(parser.getString()).append('\n');
						break;
						
					default:
						break;
				}
			}
			logger.info(sb.toString());
		}
	}

	@OnWebSocketConnect()
	public void onConnect(Session session)
	{
		logger.info(String.format("Socket Connect [0x%08x »%s«]%n", session.hashCode(), session.getRemoteAddress().toString()));

		this.session = session;
		this.observer.addSocket(this);
		try
		{
			this.observer.sendCardState(SendReason.CONNECT);
		}
		catch (CardException e)
		{
			logger.fatal(this, e);
		}
	}

	@OnWebSocketClose()
	public void onClose(Session session, int statusCode, String reason)
	{
		logger.info(String.format("Socket Close [0x%08x, %d, »%s«]%n", session.hashCode(), statusCode, reason));
		this.observer.removeSocket(this);
	}
}
