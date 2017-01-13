package com.zeppelin.insite.chipcard.test;

import javax.smartcardio.CardTerminals;
import javax.smartcardio.TerminalFactorySpi;

public class MockFactory extends TerminalFactorySpi
{
	public MockFactory()
	{
	}
	
	public MockFactory(Object params)
	{
	}
	
	@Override
	protected CardTerminals engineTerminals()
	{
		return new MockTerminals();
	}
}
