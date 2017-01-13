package com.zeppelin.insite.chipcard.cardobserver;

import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;
import javax.smartcardio.CardTerminals;

import org.apache.log4j.Logger;

public class CardStateIndeterminate implements CardState
{
	private static Logger logger = Logger.getRootLogger();
	private CardObserver cardObserver;
	private CardTerminals readers;
	private String readerName;
	private boolean firstCall = true;

	public CardStateIndeterminate(CardObserver observer, CardTerminals readers, String readerName)
	{
		assert readerName != null;

		this.cardObserver = observer;
		this.readers = readers;
		this.readerName = readerName;
	}

	@Override
	public boolean isCardPresent()
	{
		return false;
	}

	@Override
	public void waitForCard() throws CardException
	{
		boolean isOnline = false;

		CardTerminal reader = this.readers.getTerminal(this.readerName);
		if (reader != null)
		{
			this.cardObserver.setCardReader(reader);
			if (reader.isCardPresent())
			{
				this.cardObserver.setCardState(new CardStatePresent(this.cardObserver));
			}
			else
			{
				this.cardObserver.setCardState(new CardStateAbsent(this.cardObserver));
			}
			isOnline = true;
		}
		if (!(isOnline || this.firstCall))
		{
			//this.readers.waitForChange();
			try
			{
				Thread.sleep(60000); // 1 min
			}
			catch (InterruptedException e)
			{
				logger.debug(this, e);
			}
		}
		this.firstCall = false;
	}

	@Override
	public String getCardId()
	{
		return "<offline>";
	}

	@Override
	public boolean isOnline()
	{
		return false;
	}
}
