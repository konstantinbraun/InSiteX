package com.zeppelin.insite.chipcard.test.gui;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;

import org.apache.log4j.Logger;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

import com.zeppelin.insite.chipcard.CardServer;

public class ChipSim
{
	private static Logger logger = Logger.getRootLogger();
	
	public static void main(String[] args)
	{
		Display display = new Display();
		Shell shell = new Shell(display);

		CardServer cardServer = new CardServer(8080, 8443, CardServer.UseSSL.No, "Mock.Terminal", false, "chipcard");
		Thread cardThread = new Thread(cardServer.getRunMode());
		cardThread.start();

		try
		{
			final InetAddress address = InetAddress.getByName("localhost");
			final DatagramSocket udpSocket = new DatagramSocket();

			GridLayout gridLayout = new GridLayout(2, false);
			gridLayout.marginWidth = 5;
			gridLayout.marginHeight = 5;
			gridLayout.verticalSpacing = 0;
			gridLayout.horizontalSpacing = 0;
			shell.setLayout(gridLayout);
			shell.setText("Kartentest");
			final Text chipIdText = new Text(shell, SWT.BORDER);
			chipIdText.setLayoutData(new GridData(GridData.FILL, GridData.CENTER, true, true));
			Button btn = new Button(shell, SWT.TOGGLE);
			btn.setLayoutData(new GridData(GridData.END, GridData.CENTER, false, true));
			btn.addSelectionListener(new SelectionListener()
			{
				@Override
				public void widgetSelected(SelectionEvent e)
				{
					byte[] sendData;
					Button b = (Button) e.widget;
					try
					{
						if (b.getSelection())
						{
							String chipId = chipIdText.getText();
							if (chipId == null)
								return;

							if (chipId.isEmpty())
								return;

							if (chipId.length() % 2 == 1)
							{
								chipId = "0" + chipId;
							}
							sendData = new byte[(chipId.length() / 2) + 1];
							sendData[0] = (byte) (chipId.length() / 2);
							String s;
							int a;
							for (int i = 0; i < (sendData.length - 1); i++)
							{
								s = chipId.substring(i * 2, i * 2 + 2);
								a = Integer.parseInt(s, 16);
								sendData[i + 1] = (byte) a;
							}
						}
						else
						{
							sendData = new byte[1];
							sendData[0] = 0;
						}
						assert udpSocket != null;
						udpSocket.send(new DatagramPacket(sendData, sendData.length, address, 8088));
					}
					catch (NumberFormatException nfe)
					{
						logger.warn(this, nfe);
					}
					catch (IOException e1)
					{
						logger.warn(this, e1);
					}
				}

				@Override
				public void widgetDefaultSelected(SelectionEvent e)
				{}
			});
			btn.setText("Karte rein/raus");
			//shell.setSize(200, 50);
			shell.pack();
			shell.setMinimumSize(shell.getSize());
			shell.open();
			while (!shell.isDisposed())
			{
				if (!display.readAndDispatch())
				{
					display.sleep();
				}
			}
			display.dispose();

			udpSocket.close();
		}
		catch (SocketException | UnknownHostException e1)
		{
			logger.fatal("main", e1);
		}

		try
		{
			//			cardThread.interrupt();
			cardServer.stop();
			cardThread.join();
		}
		catch (Exception e)
		{
			logger.warn("main", e);
		}
	}
}
