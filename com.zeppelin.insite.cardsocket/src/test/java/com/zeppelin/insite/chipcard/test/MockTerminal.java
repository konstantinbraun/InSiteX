package com.zeppelin.insite.chipcard.test;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;

import javax.smartcardio.Card;
import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;

import org.apache.log4j.Logger;

public class MockTerminal extends CardTerminal
{
	private Logger logger = Logger.getRootLogger();
	private boolean cardPresent = false;
	private DatagramSocket udpSocket;
	private byte[] receiveData = new byte[100];
	private MockCard card = new MockCard();

	public MockTerminal()
	{
		try
		{
			this.udpSocket = new DatagramSocket(8088);
		}
		catch (SocketException e)
		{
			logger.fatal(this, e);
		}
	}
	
	@Override
	public Card connect(String protocol) throws CardException
	{
		return this.card;
	}

	@Override
	public String getName()
	{
		return "Mock.Terminal";
	}

	@Override
	public boolean isCardPresent() throws CardException
	{
		return this.cardPresent;
	}

	@Override
	public boolean waitForCardAbsent(long timeout) throws CardException
	{
		try
		{
			while (this.cardPresent)
			{
				DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
				udpSocket.receive(receivePacket);
				if (receivePacket.getData()[0] == 0)
				{
					this.cardPresent = false;
				}
			}
		}
		catch (IOException e)
		{
			logger.fatal(this, e);
		}
		return true;
	}

	@Override
	public boolean waitForCardPresent(long timeout) throws CardException
	{
		try
		{
			while (!this.cardPresent)
			{
				DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
				udpSocket.receive(receivePacket);
				byte[] data = receivePacket.getData();
				if (data[0] > 0)
				{
					this.card.chipId = data;
					this.cardPresent = true;
				}
			}
		}
		catch (IOException e)
		{
			logger.fatal(this, e);
		}
		return true;
	}
}
