package com.zeppelin.insite.chipcard;

import org.eclipse.jetty.websocket.servlet.ServletUpgradeRequest;
import org.eclipse.jetty.websocket.servlet.ServletUpgradeResponse;
import org.eclipse.jetty.websocket.servlet.WebSocketCreator;

import com.zeppelin.insite.chipcard.cardobserver.CardObserver;

public class CardSocketCreator implements WebSocketCreator
{
	private CardObserver observer;

	public CardSocketCreator(CardObserver observer)
	{
		this.observer = observer;
	}

	@Override
	public Object createWebSocket(ServletUpgradeRequest request, ServletUpgradeResponse response)
	{
		return new CardSocket(this.observer);
	}
}
