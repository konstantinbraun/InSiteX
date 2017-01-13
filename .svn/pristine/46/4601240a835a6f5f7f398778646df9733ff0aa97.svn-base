using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiteServices.ReportExecutionService;
using log4net;
using System.Xml.Linq;

namespace InsiteServices
{
    public static class Reporting
    {
        private static readonly log4net.ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static int RenderReport(string xmlParams, out byte[] output, out string extension, out string mimeType, out string comment, out string message)
        {
            // logger.InfoFormat("Enter RenderReport with param xmlParams: {0}", xmlParams);
            logger.Info("Enter RenderReport");

            IList<ParameterValue> parameters;
            string reportPath;
            string reportName;
            ExportFormat docType;
            string language;

            ParseReportParams(xmlParams, out parameters, out reportPath, out reportName, out docType, out language);

            ParameterValue parameter = parameters.Where(p => p.Name.Equals("Comment")).SingleOrDefault();
            if (parameter != null && !parameter.Value.Equals(string.Empty))
            {
                comment = parameter.Value;
            }
            else
            {
                comment = string.Empty;
            }
            output = null;
            extension = string.Empty;
            mimeType = string.Empty;
            message = string.Empty;
            string reportFullPath = string.Concat(reportPath, "/", reportName);

            logger.InfoFormat("Start exporting report {0}", reportFullPath);
            int ret = ReportExporter.Export(
                reportFullPath,
                parameters.ToArray(),
                docType,
                language,
                out output,
                out extension,
                out mimeType,
                out message);

            return ret;
        }

        private static void ParseReportParams(
            string xmlParams,
            out IList<ParameterValue> parameters,
            out string reportPath,
            out string reportName,
            out ExportFormat docType,
            out string language)
        {
            // logger.InfoFormat("Enter ParseReportParams with param xmlParams: {0}", xmlParams);
            logger.Info("Enter ParseReportParams");

            parameters = new List<ParameterValue>();
            reportPath = string.Empty;
            reportName = string.Empty;
            docType = ExportFormat.PDF;
            language = "en";

            // Parse xml
            XElement xeReport = null;
            try
            {
                xeReport = XElement.Parse(xmlParams);
            }
            catch (Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
                throw;
            }

            if (xeReport.Name != "Report")
            {
                throw new InSiteException("Unexpected structure");
            }

            // ReportName
            XElement xeReportName = (from p in xeReport.Elements("ReportName") select p).SingleOrDefault();
            if (xeReportName == null)
            {
                throw new InSiteException("ReportName not found");
            }
            reportName = xeReportName.Value;

            // ReportPath
            XElement xeReportPath = (from p in xeReport.Elements("ReportPath") select p).SingleOrDefault();
            if (xeReportPath == null)
            {
                throw new InSiteException("ReportPath not found");
            }
            reportPath = xeReportPath.Value;

            // ExportFormat
            XElement xeExportFormat = (from p in xeReport.Elements("ExportFormat") select p).SingleOrDefault();
            if (xeExportFormat == null)
            {
                throw new InSiteException("ExportFormat not found");
            }
            switch (xeExportFormat.Value.ToLower())
            {
                case "pdf":
                    docType = ExportFormat.PDF;
                    break;
                case "xls":
                    docType = ExportFormat.Excel;
                    break;
                case "csv":
                    docType = ExportFormat.CSV;
                    break;
                case "doc":
                    docType = ExportFormat.Word;
                    break;
                case "xml":
                    docType = ExportFormat.XML;
                    break;
                case "image":
                    docType = ExportFormat.Image;
                    break;
                default:
                    throw new InSiteException("Illegal export format");
            }
            
            // Language
            XElement xeLanguage = (from p in xeReport.Elements("Language") select p).SingleOrDefault();
            if (xeReportPath == null)
            {
                throw new InSiteException("Language not found");
            }
            language = xeLanguage.Value;
            
            // ReportParameters
            XElement xeReportParameters = (from p in xeReport.Elements("ReportParameters") select p).SingleOrDefault();
            if (xeReportParameters == null)
            {
                throw new InSiteException("ReportParameters not found");
            }

            // Iterate report parameters
            IEnumerable<XElement> reportParameters = from p in xeReportParameters.Elements("Parameter") select p;
            foreach (XElement reportParameter in reportParameters)
            {
                if (reportParameter.Attribute("Name") == null)
                {
                    throw new InSiteException("Name attribute not found in parameter");
                }
                parameters.Add(new ParameterValue { Name = reportParameter.Attribute("Name").Value, Value = reportParameter.Value });
            }

            //foreach(ParameterValue par in parameters.ToArray())
            //{
            //    logger.InfoFormat("<{0}>: {1}", par.Name, par.Value);
            //}
        }
    }
}