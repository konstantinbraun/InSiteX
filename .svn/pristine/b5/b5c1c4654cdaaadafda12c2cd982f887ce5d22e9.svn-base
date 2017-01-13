package com.zeppelin.insite.chipcard.test;

import java.nio.ByteBuffer;
import javax.smartcardio.Card;
import javax.smartcardio.CardChannel;
import javax.smartcardio.CardException;
import javax.smartcardio.CommandAPDU;
import javax.smartcardio.ResponseAPDU;

public class MockChannel extends CardChannel
{
	private MockCard card;
	private int channelNum;
	
	public MockChannel(MockCard mockCard, int i)
	{
		this.card = mockCard;
		this.channelNum = i;
	}

	@Override
	public void close() throws CardException
	{
	}

	@Override
	public Card getCard()
	{
		return this.card;
	}

	@Override
	public int getChannelNumber()
	{
		return this.channelNum;
	}

	@Override
	public ResponseAPDU transmit(CommandAPDU arg0) throws CardException
	{
		byte len = this.card.chipId[0];
		ByteBuffer buffer = ByteBuffer.allocate(len + 2);
		buffer.put(this.card.chipId, 1, len).put((byte) 0).put((byte) 0);
		return new ResponseAPDU(buffer.array());
		
//		int idx = 0;
//		
//		String str;
//		int a;
//		
//		// 04 3F 93 6A 25 26 80
//		
//		byteArray[idx++] = (byte) 0x04;
//		byteArray[idx++] = (byte) 0x3f;
//		byteArray[idx++] = (byte) 0x93;
//		byteArray[idx++] = (byte) 0x6a;
//		byteArray[idx++] = (byte) 0x25;
//		byteArray[idx++] = (byte) 0x26;
//		byteArray[idx++] = (byte) 0x80;
//		
////		int day = cal.get(Calendar.DAY_OF_MONTH);
////		str = String.format("%02d", day);
////		a = Integer.parseInt(str, 16);
////		byteArray[idx++] = (byte) a;
////		
////		int month = cal.get(Calendar.MONTH) + 1;
////		str = String.format("%02d", month);
////		a = Integer.parseInt(str, 16);
////		byteArray[idx++] = (byte) a;
////		
////		int year = cal.get(Calendar.YEAR);
////		int century = year / 100;
////		year %= 100;
////		str = String.format("%02d", century);
////		a = Integer.parseInt(str, 16);
////		byteArray[idx++] = (byte) a;
////		
////		str = String.format("%02d", year);
////		a = Integer.parseInt(str, 16);
////		byteArray[idx++] = (byte) a;
////		
////		byteArray[idx++] = (byte) 0xFF;
////		
////		int hour = cal.get(Calendar.HOUR_OF_DAY);
////		str = String.format("%02d", hour);
////		a = Integer.parseInt(str, 16);
////		byteArray[idx++] = (byte) a;
////		
////		int minute = cal.get(Calendar.MINUTE);
////		str = String.format("%02d", minute);
////		a = Integer.parseInt(str, 16);
////		byteArray[idx++] = (byte) a;
////		
////		int sec = cal.get(Calendar.SECOND);
////		str = String.format("%02d", sec);
////		a = Integer.parseInt(str, 16);
////		byteArray[idx++] = (byte) a;
//		
//		byteArray[idx++] = 0;
//		byteArray[idx++] = 0;
//		
//		return new ResponseAPDU(byteArray);
	}
	
	@Override
	public int transmit(ByteBuffer arg0, ByteBuffer arg1) throws CardException
	{
		return 0;
	}
}
