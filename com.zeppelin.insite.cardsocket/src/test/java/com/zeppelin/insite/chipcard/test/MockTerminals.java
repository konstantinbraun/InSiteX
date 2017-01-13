package com.zeppelin.insite.chipcard.test;

import java.util.ArrayList;
import java.util.List;

import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;
import javax.smartcardio.CardTerminals;

public class MockTerminals extends CardTerminals
{
	@Override
	public List<CardTerminal> list(State state) throws CardException
	{
		List<CardTerminal> terminals = new ArrayList<CardTerminal>();
		switch (state)
		{
			case ALL:
			case CARD_PRESENT:
			case CARD_INSERTION:
				terminals.add(new MockTerminal());
				break;
			default:
				break;

		}
		return terminals;
	}

	@Override
	public boolean waitForChange(long l) throws CardException
	{
		return true;
	}
}
