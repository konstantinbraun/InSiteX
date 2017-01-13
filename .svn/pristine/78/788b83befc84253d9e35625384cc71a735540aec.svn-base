package com.zeppelin.insite.chipcard.cardobserver;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import javax.json.Json;
import javax.json.JsonObjectBuilder;
import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;
import javax.smartcardio.CardTerminals;

import org.apache.log4j.Logger;

import com.zeppelin.insite.chipcard.CardSocket;

public class CardObserver
{
	private static Logger logger = Logger.getRootLogger();
	
	private List<CardSocket> sockets = new LinkedList<>();
	private CardTerminal cardReader = null;
	private boolean reverseCardId;

	private CardState cardState;
	private Thread observerThread;

	public enum SendReason
	{
		REQUEST, CONNECT, TRIGGER;
	}

	public CardObserver(CardTerminals readers, String readerName, boolean reverseCardId)
	{
		this.reverseCardId = reverseCardId;
		this.cardState = new CardStateIndeterminate(this, readers, readerName);
		observerThread = new Thread(new Runnable()
		{
			@Override
			public void run()
			{
				while (!Thread.interrupted())
				{
					try
					{
						cardState.waitForCard();
						sendCardState(SendReason.TRIGGER);
					}
					catch (CardException e)
					{
						logger.info(this, e);

						// ein Service-Thread hat seine Unterbrechung als
						// CardException weitergegeben, wir versuchen einen
						// sauberen Rückzug
						if (e.getCause() instanceof InterruptedException)
						{
							Thread.currentThread().interrupt();
						}
						else
						{
							CardObserver.this.setCardState(new CardStateIndeterminate(CardObserver.this, readers, readerName));
//							try
//							{
//								Thread.sleep(60000); // 1 min
//							}
//							catch (InterruptedException e1)
//							{
//								logger.info(this, e1);
//								//								Thread.currentThread().interrupt();
//							}
						}
					}
				}
				try
				{
					disconnectSockets();
				}
				catch (IOException e)
				{
					logger.fatal(this, e);
				}
			}
		});
		observerThread.start();
	}

	public void terminate() throws InterruptedException
	{
		this.observerThread.interrupt();
		this.observerThread.join();
	}

	protected void disconnectSockets() throws IOException
	{
		synchronized (this.sockets)
		{
			for (CardSocket s : this.sockets)
			{
				s.getSession().disconnect();
			}
		}
	}

	public void addSocket(CardSocket socket)
	{
		synchronized (this.sockets)
		{
			this.sockets.add(socket);
		}
	}

	public void removeSocket(CardSocket socket)
	{
		synchronized (this.sockets)
		{
			this.sockets.remove(socket);
		}
	}

	void setCardState(CardState newCardState)
	{
		this.cardState = newCardState;
	}

	CardState getCardState()
	{
		return this.cardState;
	}

	public CardTerminal getCardReader()
	{
		return this.cardReader;
	}

	void setCardReader(CardTerminal reader)
	{
		this.cardReader = reader;
	}

	public void sendMessage(String string)
	{}

	public void sendCardState(SendReason reason) throws CardException
	{
		String cardId = this.cardState.getCardId();
		boolean cardPresent = this.cardState.isCardPresent();
		boolean readerOnline = this.getCardState().isOnline();

		JsonObjectBuilder builder = Json.createObjectBuilder();
		builder.add("reason", reason.name().toLowerCase());
		builder.add("online", readerOnline);
		if (readerOnline)
		{
			builder.add("cardPresent", cardPresent);
			if (cardPresent)
			{
				builder.add("cardId", cardId);
			}
		}

		synchronized (CardObserver.this.sockets)
		{
			logger.debug(String.format("Sending card [%d] status …\n", CardObserver.this.sockets.size()));
			String msg = builder.build().toString();
			for (CardSocket socket : CardObserver.this.sockets)
			{
				this.sendText(socket, msg);
			}
		}
	}

	private void sendText(CardSocket socket, String text)
	{
		if (socket.getSession().isOpen())
		{
			try
			{
				socket.getSession().getRemote().sendString(text);
				logger.debug(String.format("\tMessage send [0x%08x]\n%s\n", socket.getSession().hashCode(), text));
			}
			catch (IOException e)
			{
				logger.debug(String.format("\tMessage send failed:\n%s\n", e.getMessage()));
			}
		}
	}

	boolean hasReversedCardId()
	{
		return this.reverseCardId;
	}
}
