package com.zeppelin.insite.chipcard;

import javax.servlet.annotation.WebServlet;
import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;
import javax.smartcardio.CardTerminals;
import javax.smartcardio.TerminalFactory;

import org.apache.log4j.Logger;
import org.eclipse.jetty.websocket.servlet.WebSocketServlet;
import org.eclipse.jetty.websocket.servlet.WebSocketServletFactory;

import com.zeppelin.insite.chipcard.cardobserver.CardObserver;

/**
 * Servlet implementation class CardServlet
 */
@WebServlet(name = "Card WebSocket Servlet")
public class CardServlet extends WebSocketServlet
{
	private static final long serialVersionUID = 1L;
	private static Logger logger = Logger.getRootLogger();

	public static final String ReaderNameParameter = "ReaderName";
	public static final String ReverseCardIdParameter = "ReverseCardId";

	String readerName;
	boolean reverseCardId = false;
	private CardObserver observer;

	@Override
	public void configure(WebSocketServletFactory factory)
	{
		this.readerName = getServletContext().getInitParameter(ReaderNameParameter);
		assert this.readerName != null && !this.readerName.isEmpty();

		String v = getServletContext().getInitParameter(ReverseCardIdParameter);
		assert v != null && !v.isEmpty();
		reverseCardId = "true".equalsIgnoreCase(v);

		TerminalFactory readerFactory;
		//		try
		//		{
		//			readerFactory = TerminalFactory.getInstance("MockCard", null);
		//		}
		//		catch (NoSuchAlgorithmException e)
		//		{
		//			logger.debug(this, e);
		readerFactory = TerminalFactory.getDefault();
		//		}
		CardTerminals readers = readerFactory.terminals();
		assert readers != null;

		if (logger.isDebugEnabled())
		{
			try
			{
				for (CardTerminal t : readers.list())
				{
					logger.debug(String.format("Name: %s\n", t.getName()));
				}
			}
			catch (CardException e)
			{
				logger.debug(this, e);
			}
		}

		observer = new CardObserver(readers, this.readerName, reverseCardId);
		factory.getPolicy().setIdleTimeout(0);
		factory.setCreator(new CardSocketCreator(observer));
	}
	
	@Override
	public void destroy()
	{
		logger.info("### SERVLET DESTROY ###");
		assert this.observer != null;
		try
		{
			this.observer.terminate();
		}
		catch (InterruptedException e)
		{
			logger.debug(this, e);
		}
		super.destroy();
	}
}
