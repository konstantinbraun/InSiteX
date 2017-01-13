package com.zeppelin.insite.chipcard.cardobserver;

import javax.smartcardio.CardException;

public interface CardState
{
	boolean isOnline();
	boolean isCardPresent() throws CardException;
	void waitForCard() throws CardException;
	String getCardId();
}
