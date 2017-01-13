package com.zeppelin.insite.chipcard.test;

import java.security.AccessController;
import java.security.PrivilegedAction;
import java.security.Provider;

@SuppressWarnings("serial")
public class MockProvider extends Provider
{
	public MockProvider()
	{
		super("MockCard", 1.0d, "Mock Card Terminal Provider");
		AccessController.doPrivileged(new PrivilegedAction<Object>()
		{
			@Override
			public Object run()
			{
				put("TerminalFactory.MockCard", "com.zeppelin.insite.chipcard.test.MockFactory");
				return null;
			}
		});
	}
}
