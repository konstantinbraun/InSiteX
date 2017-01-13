package com.zeppelin.insite.chipcard.test;

import javax.smartcardio.ATR;
import javax.smartcardio.Card;
import javax.smartcardio.CardChannel;
import javax.smartcardio.CardException;

public class MockCard extends Card
{
	private MockChannel channel;
	byte[] chipId;

	public MockCard()
	{
		this.channel = new MockChannel(this, 0);
	}

	@Override
	public void beginExclusive() throws CardException
	{}

	@Override
	public void disconnect(boolean reset) throws CardException
	{}

	@Override
	public void endExclusive() throws CardException
	{}

	@Override
	public ATR getATR()
	{
		return null;
	}

	@Override
	public CardChannel getBasicChannel()
	{
		return this.channel;
	}

	@Override
	public String getProtocol()
	{
		return "T=0";
	}

	@Override
	public CardChannel openLogicalChannel() throws CardException
	{
		return this.channel;
	}

	@Override
	public byte[] transmitControlCommand(int arg0, byte[] arg1) throws CardException
	{
		return null;
	}
}
