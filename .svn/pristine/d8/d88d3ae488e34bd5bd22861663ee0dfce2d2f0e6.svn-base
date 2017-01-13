using InsiteServices.ReportExecutionService;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Services.Protocols;

namespace InsiteServices
{
    #region enum ExportFormat
    
    /// <summary>
    /// Export Formats.
    /// </summary>
    public enum ExportFormat
    {
        /// <summary>XML</summary>
        XML,
        /// <summary>Comma Delimitted File
        CSV,
        /// <summary>TIFF image</summary>
        Image,
        /// <summary>PDF</summary>
        PDF,
        /// <summary>HTML (Web Archive)</summary>
        MHTML,
        /// <summary>HTML 4.0</summary>
        HTML4,
        /// <summary>HTML 3.2</summary>
        HTML32,
        /// <summary>Excel</summary>
        Excel,
        /// <summary>Word</summary>
        Word
    }
    
    #endregion
    
    /// <summary>
    /// Utility class that renders and exports a SQL Reporting Services report into the specified output format.
    /// </summary>
    public static class ReportExporter
    {
        private static readonly log4net.ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        
        #region Method: GetExportFormatString(ExportFormat f)
        
        /// <summary>
        /// Gets the string export format of the specified enum.
        /// </summary>
        /// <param name="f">export format enum</param>
        /// <returns>enum equivalent string export format</returns>
        private static string GetExportFormatString(ExportFormat f)
        {
            switch (f)
            {
                case ExportFormat.XML:
                    return "XML";
                case ExportFormat.CSV:
                    return "CSV";
                case ExportFormat.Image:
                    return "IMAGE";
                case ExportFormat.PDF:
                    return "PDF";
                case ExportFormat.MHTML:
                    return "MHTML";
                case ExportFormat.HTML4:
                    return "HTML4.0";
                case ExportFormat.HTML32:
                    return "HTML3.2";
                case ExportFormat.Excel:
                    return "EXCEL";
                case ExportFormat.Word:
                    return "WORD";
                
                default:
                    return "PDF";
            }
        }
        
        #endregion
        
        #region Method: Export( ... )
        
        /// <summary>
        /// Exports a Reporting Service Report to the specified format using Windows Communication Foundation (WCF) endpoint configuration specified.
        /// </summary>
        /// <param name="report">Reporting Services Report to execute</param>
        /// <param name="parameters">report parameters</param>
        /// <param name="format">export output format (e.g., XML, CSV, IMAGE, PDF, HTML4.0, HTML3.2, MHTML, EXCEL, and HTMLOWC)</param>
        /// <param name="language">report language</param>
        /// <param name="output">rendering output result in bytes</param>
        public static int Export(
            string report,
            ParameterValue[] parameters,
            ExportFormat format,
            string language,
            out byte[] output,
            out string extension,
            out string mimeType,
            out string message)
        {
            int ret = 0;

            output = null;
            extension = string.Empty;
            mimeType = string.Empty;
            message = string.Empty;

            using (var webServiceProxy = new ReportExecutionServiceSoapClient())
            {
                webServiceProxy.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
                string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
                string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
                string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
                NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
                webServiceProxy.ClientCredentials.Windows.ClientCredential = clientCredentials;
                
                // Init Report to execute
                ServerInfoHeader serverInfoHeader;
                ExecutionInfo executionInfo;
                ExecutionHeader executionHeader = null;

                try
                {
                    executionHeader = webServiceProxy.LoadReport(null, report, null, out serverInfoHeader, out executionInfo);
                }
                catch (SoapException ex)
                {
                    ret = -1;
                    message = ex.Detail.InnerXml.ToString();
                    logger.ErrorFormat("SOAP exeption: {0}", message);
                }
                catch (Exception ex)
                {
                    ret = -2;
                    message = ex.Message;
                    logger.ErrorFormat("Webservice error: {0}", message);
                }

                if (ret == 0)
                {
                    // Attach Report Parameters
                    try
                    {
                        webServiceProxy.SetExecutionParameters(executionHeader, null, parameters, language, out executionInfo);
                    }
                    catch (SoapException ex)
                    {
                        ret = -1;
                        message = ex.Detail.InnerXml.ToString();
                        logger.ErrorFormat("SOAP exeption: {0}", message);
                    }
                    catch (Exception ex)
                    {
                        ret = -2;
                        message = ex.Message;
                        logger.ErrorFormat("Webservice error: {0}", message);
                    }
                }
                
                string encoding; 
                Warning[] warnings; 
                string[] streamIds;

                if (ret == 0)
                {
                    // Render
                    try
                    {
                        webServiceProxy.Render(executionHeader, null, GetExportFormatString(format), null, out output, out extension, out mimeType, out encoding, out warnings, out streamIds);
                    }
                    catch (SoapException ex)
                    {
                        ret = -1;
                        message = ex.Detail.InnerXml.ToString();
                        logger.ErrorFormat("SOAP exeption: {0}", message);
                    }
                    catch (Exception ex)
                    {
                        ret = -2;
                        message = ex.Message;
                        logger.ErrorFormat("Webservice error: {0}", message);
                    }
                }
            }

            return ret;
        }
    
        #endregion
    }
}