package com.zeppelin.insite.chipcard;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Paths;
import java.util.Properties;

import javax.smartcardio.CardException;
import javax.smartcardio.CardTerminal;
import javax.smartcardio.TerminalFactory;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.log4j.Logger;
import org.eclipse.jetty.http.HttpVersion;
import org.eclipse.jetty.server.HttpConfiguration;
import org.eclipse.jetty.server.HttpConnectionFactory;
import org.eclipse.jetty.server.SecureRequestCustomizer;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.server.SslConnectionFactory;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.util.ssl.SslContextFactory;

public class CardServer
{
	public enum UseSSL
	{
		No, // no SSL
		Optional, // both
		Only // only SSL
	}

	private static Logger logger = Logger.getRootLogger();
	private static final String DEFAULT_PATH = "chipcard";
	private static final String DEFAULT_READER_NAME = "Identive CLOUD 4710 F Contactless Reader 0";
	private static final Integer DEFAULT_PORT = 8080;
	private static final Integer DEFAULT_SSL_PORT = 8443;

	private static final String LONG_OPT_PORT = "port";
	private static final String LONG_OPT_SSL_PORT = "ssl-port";
	private static final String LONG_OPT_READER = "reader-name";
	private static final String LONG_OPT_REVERSE = "reverse";
	private static final String LONG_OPT_PATH = "path";
	private static final String LONG_OPT_HELP = "help";
	private static final String LONG_OPT_LIST = "list-readers";
	private static final String LONG_OPT_USE_SSL = "use-ssl";

	private Integer port;
	private Integer sslPort;
	private UseSSL useSSL;
	private String readerName;
	private Boolean reverseCardId;
	private String path;
	private Runnable runMode;
	private Options opts;
	private Server server;

	class Configuration
	{

		int port;
		int sslPort;
		UseSSL useSSL;
		String readerName;
		boolean reverse;
		String path;

		Configuration()
		{
			this.port = DEFAULT_PORT;
			this.sslPort = DEFAULT_SSL_PORT;
			this.useSSL = UseSSL.No;
			this.readerName = DEFAULT_READER_NAME;
			this.reverse = false;
			this.path = DEFAULT_PATH;
		}

		Configuration(int port, int sslPort, UseSSL useSSL, String readerName, boolean reverseCardId, String path)
		{
			this.port = port;
			this.sslPort = sslPort;
			this.useSSL = useSSL;
			this.readerName = readerName;
			this.reverse = reverseCardId;
			this.path = path;
		}
	}

	private Runnable serverMode = new Runnable()
	{
		@Override
		public void run()
		{
			//			Security.addProvider(new MockProvider());

			server = new Server();

			if (CardServer.this.useSSL != UseSSL.Only)
			{
				ServerConnector connector = new ServerConnector(server);
				connector.setPort(CardServer.this.port);
				connector.setHost("localhost");
				server.addConnector(connector);
			}

			if (CardServer.this.useSSL != UseSSL.No)
			{
				SslContextFactory sslCtxFactory = new SslContextFactory();
				URL keystoreUrl = CardServer.class.getResource("/keystore.jks");
				assert (keystoreUrl != null);
				sslCtxFactory.setKeyStorePath(keystoreUrl.toExternalForm());
				sslCtxFactory.setKeyStorePassword("aGxGsVQP");
				sslCtxFactory.setKeyManagerPassword("aGxGsVQP");
				sslCtxFactory.setCertAlias("localhost");

				HttpConfiguration https = new HttpConfiguration();
				https.addCustomizer(new SecureRequestCustomizer());

				ServerConnector connector = new ServerConnector(server, new SslConnectionFactory(sslCtxFactory, HttpVersion.HTTP_1_1.asString()), new HttpConnectionFactory(https));
				connector.setHost("localhost");
				connector.setPort(CardServer.this.sslPort);
				server.addConnector(connector);
			}

			// Setup the basic application "context" for this application at "/"
			// This is also known as the handler tree (in jetty speak)
			ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
			context.setContextPath("/");

			// Add a websocket to a specific path spec
			ServletHolder holderEvents = new ServletHolder("ws-events", CardServlet.class);
			context.addServlet(holderEvents, CardServer.this.path.toString());
			context.setInitParameter(CardServlet.ReaderNameParameter, CardServer.this.readerName);
			context.setInitParameter(CardServlet.ReverseCardIdParameter, reverseCardId.toString());

			try
			{
				Properties p = new Properties();
				p.setProperty("org.eclipse.jetty.LEVEL", "WARN");
				p.setProperty("org.eclipse.jetty.server.Server.LEVEL", "WARN");
				org.eclipse.jetty.util.log.StdErrLog.setProperties(p);

				server.setHandler(context);
				server.start();
				server.dump(System.err);
				server.join();
			}
			catch (Exception e)
			{
				logger.fatal(this, e);
			}
		}
	};

	private Runnable helpMode = new Runnable()
	{
		@Override
		public void run()
		{
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp("CardServer", CardServer.this.opts, true);
		}
	};

	private Runnable listMode = new Runnable()
	{
		@Override
		public void run()
		{
			try
			{
				TerminalFactory readerFactory = TerminalFactory.getDefault();
				for (CardTerminal t : readerFactory.terminals().list())
				{
					System.out.println(t.getName());
				}
			}
			catch (CardException e)
			{
				logger.fatal(this, e);
			}

		}
	};

	public static void main(String[] args)
	{
		try
		{
			new CardServer(args).run();
		}
		catch (Exception e)
		{
			logger.fatal("main", e);
		}
	}

	private CardServer(String[] args)
	{
		try
		{
			Configuration cfg = new Configuration();
			this.initFromProperties(cfg);

			this.opts = new Options();

			this.opts.addOption(Option.builder().longOpt(LONG_OPT_PORT).required(false).hasArg(true).argName("port number").desc("WebSocket port (e. g. ‘8080’)").build());
			this.opts.addOption(Option.builder().longOpt(LONG_OPT_SSL_PORT).required(false).hasArg(true).argName("SSL port number").desc("WebSocket SSL port (e. g. ‘8443’)").build());
			this.opts.addOption(Option.builder().longOpt(LONG_OPT_READER).required(false).hasArg(true).argName("name").desc("name of card reader (e. g. ‘Identive CLOUD 4710 F Contactless Reader 0’)").build());
			this.opts.addOption(Option.builder().longOpt(LONG_OPT_REVERSE).required(false).hasArg(false).desc("reverse card id").build());
			this.opts.addOption(Option.builder().longOpt(LONG_OPT_PATH).required(false).hasArg(true).argName("path").desc("path part for WebSocket-URI (e. g. ‘chipcard’, without leading or trailing slash)").build());
			this.opts.addOption(Option.builder().longOpt(LONG_OPT_HELP).required(false).hasArg(false).desc("print this message").build());
			this.opts.addOption(Option.builder().longOpt(LONG_OPT_LIST).required(false).hasArg(false).desc("list available readers").build());
			this.opts.addOption(Option.builder().longOpt(LONG_OPT_USE_SSL).required(false).hasArg(true).optionalArg(true).argName("only").desc("usage of SSL").build());

			CommandLineParser clp = new DefaultParser();
			CommandLine cl = clp.parse(this.opts, args);

			if (cl.hasOption(LONG_OPT_HELP))
			{
				this.runMode = this.helpMode;
			}
			else if (cl.hasOption(LONG_OPT_LIST))
			{
				this.runMode = this.listMode;
			}
			else
			{
				if (cl.hasOption(LONG_OPT_PORT))
				{
					String propValue = cl.getOptionValue(LONG_OPT_PORT);
					try
					{
						cfg.port = Integer.valueOf(propValue);
					}
					catch (NumberFormatException e)
					{
						logger.warn(String.format("Port %s is not valid.", propValue));
					}
				}
				if (cl.hasOption(LONG_OPT_SSL_PORT))
				{
					String propValue = cl.getOptionValue(LONG_OPT_SSL_PORT);
					try
					{
						cfg.sslPort = Integer.valueOf(propValue);
					}
					catch (NumberFormatException e)
					{
						logger.warn(String.format("SSL port %s is not valid.", propValue));
					}
				}
				if (cl.hasOption(LONG_OPT_READER))
				{
					cfg.readerName = cl.getOptionValue(LONG_OPT_READER);
				}
				if (cl.hasOption(LONG_OPT_REVERSE))
				{
					cfg.reverse = Boolean.valueOf(cl.getOptionValue(LONG_OPT_REVERSE));
				}
				if (cl.hasOption(LONG_OPT_PATH))
				{
					cfg.path = cl.getOptionValue(LONG_OPT_PATH);
				}
				if (cl.hasOption(LONG_OPT_USE_SSL))
				{
					cfg.useSSL = UseSSL.Optional;
					if ("only".equalsIgnoreCase(cl.getOptionValue(LONG_OPT_USE_SSL)))
					{
						cfg.useSSL = UseSSL.Only;
					}
				}
				this.init(cfg);
			}
		}
		catch (ParseException e)
		{
			logger.warn(this, e);
			this.runMode = this.helpMode;
		}
		catch (IOException e)
		{
			logger.warn(this, e);
		}
	}

	private void initFromProperties(Configuration cfg) throws IOException
	{
		final String propertyFilename = "config.properties";

		File propFile;
		try
		{
			propFile = Paths.get(CardServer.class.getResource("/" + propertyFilename).toURI()).toFile();
			try (InputStream propStream = new BufferedInputStream(new FileInputStream(propFile)))
			{
				Properties props = new Properties();
				props.load(propStream);

				// reader name
				String propValue = props.getProperty("reader-name", DEFAULT_READER_NAME);
				cfg.readerName = propValue;

				// port
				try
				{
					propValue = props.getProperty("port", DEFAULT_PORT.toString());
					cfg.port = Integer.valueOf(propValue);
				}
				catch (NumberFormatException e)
				{
					logger.warn(String.format("Port %s is not valid. Fall back to default %d", propValue, DEFAULT_PORT));
					cfg.port = DEFAULT_PORT;
				}

				// SSL port
				try
				{
					propValue = props.getProperty("ssl-port", DEFAULT_SSL_PORT.toString());
					cfg.sslPort = Integer.valueOf(propValue);
				}
				catch (NumberFormatException e)
				{
					logger.warn(String.format("SSL port %s is not valid. Fall back to default %d", propValue, DEFAULT_SSL_PORT));
					cfg.sslPort = DEFAULT_SSL_PORT;
				}

				// use SSL
				propValue = props.getProperty("use-ssl");
				if (propValue == null)
				{
					cfg.useSSL = UseSSL.No;
				}
				else if (propValue.equalsIgnoreCase("only"))
				{
					cfg.useSSL = UseSSL.Only;
				}
				else
				{
					cfg.useSSL = UseSSL.Optional;
				}

				// reverse
				propValue = props.getProperty("reverse", "false");
				cfg.reverse = Boolean.valueOf(propValue);

				// path
				propValue = props.getProperty("path", DEFAULT_PATH);
				cfg.path = propValue;
			}
			catch (FileNotFoundException e)
			{
				logger.info(e.getMessage());
			}
			catch (IOException e)
			{
				logger.error(String.format("Could’nt load properties from “%s”", propertyFilename), e);
			}
		}
		catch (URISyntaxException e)
		{
			logger.info(e.getMessage());
		}
	}

	public CardServer()
	{
		this.init(new Configuration());
	}

	public CardServer(int port, int sslPort, UseSSL useSSL, String readerName, boolean reverseCardId, String pathPart)
	{
		this.init(new Configuration(port, sslPort, useSSL, readerName, reverseCardId, pathPart));
	}

	private void init(Configuration config)
	{
		StringBuilder pathBuilder = new StringBuilder();
		if (!config.path.startsWith("/"))
		{
			pathBuilder.append('/');
		}
		pathBuilder.append(config.path);
		if (!config.path.endsWith("/"))
		{
			pathBuilder.append('/');
		}
		pathBuilder.append('*');

		this.path = pathBuilder.toString();
		this.port = config.port;
		this.sslPort = config.sslPort;
		this.useSSL = config.useSSL;
		this.readerName = config.readerName;
		this.reverseCardId = config.reverse;

		logger.info(String.format("configuration:\n\tport=%d\n\tssl port=%d\n\tuse ssl=%s\n\tpath=%s\n\treader=%s\n\treverse=%s\n", this.port, this.sslPort, this.useSSL.toString(), this.path, this.readerName, this.reverseCardId.toString()));

		this.runMode = this.serverMode;
	}

	public Runnable getRunMode()
	{
		return this.runMode;
	}

	private void run() throws Exception
	{
		this.runMode.run();
	}

	public void stop() throws Exception
	{
		this.server.stop();
	}
}
