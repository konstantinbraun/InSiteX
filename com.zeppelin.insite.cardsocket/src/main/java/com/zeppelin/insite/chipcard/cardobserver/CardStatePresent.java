package com.zeppelin.insite.chipcard.cardobserver;

import javax.smartcardio.Card;
import javax.smartcardio.CardChannel;
import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;
import javax.smartcardio.CommandAPDU;
import javax.smartcardio.ResponseAPDU;

import org.apache.log4j.Logger;

public class CardStatePresent implements CardState
{
	private static Logger logger = Logger.getRootLogger();
	private CardObserver cardObserver;
	private CardTerminal cardTerminal;

	public CardStatePresent(CardObserver observer)
	{
		this.cardObserver = observer;
		this.cardTerminal = observer.getCardReader();
	}
	
	@Override
	public boolean isCardPresent() throws CardException
	{
		return this.cardTerminal.isCardPresent();
	}

	@Override
	public void waitForCard() throws CardException
	{
		if (this.cardTerminal.waitForCardAbsent(0))
		{
			this.cardObserver.sendMessage("card absent");
			this.cardObserver.setCardState(new CardStateAbsent(this.cardObserver));
		}
	}

	@Override
	public String getCardId()
	{
		String retString = "N/A";
		try {
			if (this.cardTerminal.isCardPresent()) {
				Card myCard = this.cardTerminal.connect("*");
				CardChannel myChannel = myCard.getBasicChannel();
//				byte[] myAPDUArray = { (byte) 0xFF, (byte) 0xCA, (byte) 0x00, (byte) 0x00, (byte) 0x00 };	// serial number
				
//				byte[] myAPDUArray = { (byte) 0xFF, (byte) 0xCC,	// escape command 
//						               (byte) 0x00, (byte) 0x00,
//						               (byte) 0x01,					// Lc (escape command length)
//						               (byte) 0xDA,					// CNTLESS_GET_CARD_DETAILS
//						               (byte) 20 };					// Le (result length)
				byte[] myAPDUArray = { (byte) 0xFF, (byte) 0xEF,	// CL pass thru 
			               (byte) 0x01, (byte) 0x00,				// P1=discard CRC, P2
			               (byte) 0x02,								// Lc (command length)
			               (byte) 0x93,								// ANTICOLLISION
			               (byte) 0x20};							// NVB (number of valid bits)
			               //(byte) 0x06};							// return length
				
				CommandAPDU myAPDU = new CommandAPDU(myAPDUArray);
				ResponseAPDU myResponse = myChannel.transmit(myAPDU);
				logger.debug(String.format("SW1: %02x\nSW2: %02x\n\n",  myResponse.getSW1(), myResponse.getSW2()));
				byte[] retBuffer = myResponse.getData();
				
				StringBuilder sb = new StringBuilder();
				
				if (this.cardObserver.hasReversedCardId()) {
					for (byte b : retBuffer)
					{
						sb.insert(0, String.format("%02X", b));
					}
				}
				else {
					for (byte b : retBuffer)
					{
						sb.append(String.format("%02X", b));
					}
				}
				retString = sb.toString();
			}
		} catch (CardException e) {
			logger.fatal(this, e);
		}
		return retString;
	}

	@Override
	public boolean isOnline()
	{
		return true;
	}
}
