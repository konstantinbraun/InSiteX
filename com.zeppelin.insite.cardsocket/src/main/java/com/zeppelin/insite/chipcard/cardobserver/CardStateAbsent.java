package com.zeppelin.insite.chipcard.cardobserver;

import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;

public class CardStateAbsent implements CardState
{
	private CardObserver cardObserver;
	private CardTerminal cardTerminal;

	public CardStateAbsent(CardObserver observer)
	{
		this.cardObserver = observer;
		this.cardTerminal = observer.getCardReader();
	}
	
	@Override
	public boolean isCardPresent()
	{
		return false;
	}

	@Override
	public void waitForCard() throws CardException
	{
		if (this.cardTerminal.waitForCardPresent(0))
		{
			this.cardObserver.sendMessage("card present");
			this.cardObserver.setCardState(new CardStatePresent(this.cardObserver));
		}
	}

	@Override
	public String getCardId()
	{
		return null;
	}

	@Override
	public boolean isOnline()
	{
		return true;
	}
}
