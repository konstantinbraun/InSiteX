using InsiteServices.Constants;
using InsiteServices.Models;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;

namespace InsiteServices
{
    public class ContainerManagement : IContainerManagement
    {
        private static ILog logger;
        private Insite_DevEntities entities;
        private static string cmServer;
        private static string cmUser;
        private static string cmPassword;

        /// <summary>
        /// Standardkonstruktor
        /// </summary>
        public ContainerManagement()
        {
            logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            InitializeContext();
        }

        /// <summary>
        /// InitializeContext
        /// </summary>
        private void InitializeContext()
        {
            entities = new Insite_DevEntities();
            cmServer = ConfigurationManager.AppSettings["CMServer"].ToString();
            cmUser = ConfigurationManager.AppSettings["CMUser"].ToString();
            cmPassword = ConfigurationManager.AppSettings["CMPassword"].ToString();
        }

        /// <summary>
        /// Insert, Update or delete employee data
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="dataAction"></param>
        /// <returns></returns>
        public string EmployeeData(int systemID, int bpID, int employeeID, int dataAction)
        {
            logger.InfoFormat("Enter EmployeeData with param systemID: {0}; bpID: {1}; employeeID: {2}; dataAction: {3}", systemID, bpID, employeeID, dataAction);
            HttpWebResponse response = null;
            try
            {
                ObjectResult<GetEmployeeContainerManagement_Result> result = entities.GetEmployeeContainerManagement(systemID, bpID, employeeID);
                GetEmployeeContainerManagement_Result[] employees = result.ToArray();
                if (employees.Count() > 0)
                {
                    if (employees[0].ContainerManagementName != null && !employees[0].ContainerManagementName.Equals(string.Empty))
                    {
                        string jsonString;
                        string dataUrl = cmServer + "personal/" + employees[0].ContainerManagementName;

                        if (employees.Count() == 1)
                        {
                            // Single item
                            if (dataAction != Actions.Insert)
                            {
                                dataUrl += "/" + employees[0].EmployeeID.ToString();
                            }

                            Personal personal = new Personal();

                            personal.ID = employees[0].EmployeeID;
                            personal.Ausweis_ID = Convert.ToInt32(employees[0].ExternalID);
                            personal.Vorname = employees[0].FirstName;
                            personal.Name = employees[0].LastName;
                            personal.Arbeitgeber = employees[0].CompanyID;
                            personal.Gewerk = employees[0].TradeID;
                            personal.Entsorgungsfachkraft = employees[0].IsDisposalExpert;
                            personal.Telefon = employees[0].Phone;

                            jsonString = personal.ToJson();
                        }
                        else
                        {
                            // All items
                            List<Personal> listPersonal = new List<Personal>();
                            foreach (GetEmployeeContainerManagement_Result employee in employees)
                            {
                                Personal personal = new Personal();

                                personal.ID = employee.EmployeeID;
                                personal.Ausweis_ID = Convert.ToInt32(employee.ExternalID);
                                personal.Vorname = employee.FirstName;
                                personal.Name = employee.LastName;
                                personal.Arbeitgeber = employee.CompanyID;
                                personal.Gewerk = employee.TradeID;
                                personal.Entsorgungsfachkraft = employee.IsDisposalExpert;
                                personal.Telefon = employee.Phone;

                                listPersonal.Add(personal);
                            }
                            jsonString = listPersonal.ToJson();
                            dataAction = Actions.Update;
                        }

                        if (dataAction == Actions.Insert)
                        {
                            response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Post, jsonString);
                        }
                        else if (dataAction == Actions.Update)
                        {
                            response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Put, jsonString);
                        }
                        else if (dataAction == Actions.Delete)
                        {
                            response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Delete, jsonString);
                        }
                    }
                }
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

            string ret = string.Empty;
            if (response != null)
            {
                ret = (int)response.StatusCode + " - " + response.StatusCode;
            }

            return ret;
        }

        /// <summary>
        /// Insert, Update or delete company data
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="dataAction"></param>
        /// <returns></returns>
        public string CompanyData(int systemID, int bpID, int companyID, int dataAction)
        {
            logger.InfoFormat("Enter CompanyData with param systemID: {0}; bpID: {1}; companyID: {2}; dataAction: {3}", systemID, bpID, companyID, dataAction);
            HttpWebResponse response = null;
            ObjectResult<GetCompanyContainerManagement_Result> result = entities.GetCompanyContainerManagement(systemID, bpID, companyID);
            GetCompanyContainerManagement_Result[] companies = result.ToArray();
            if (companies.Count() > 0)
            {
                if (bpID == 0)
                {
                    // Change in central companies master, change all relevant bp companies
                    foreach (GetCompanyContainerManagement_Result company in companies)
                    {
                        if (company.ContainerManagementName != null && !company.ContainerManagementName.Equals(string.Empty))
                        {
                            string jsonString;
                            string dataUrl = cmServer + "firma/" + company.ContainerManagementName;

                            if (dataAction != Actions.Insert)
                            {
                                dataUrl += "/" + company.CompanyID.ToString();
                            }

                            Firma firma = new Firma();

                            firma.ID = company.CompanyID;
                            firma.Name = company.NameVisible;

                            jsonString = firma.ToJson();

                            if (dataAction == Actions.Update)
                            {
                                response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Put, jsonString);
                            }
                            else if (dataAction == Actions.Delete)
                            {
                                response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Delete, jsonString);
                            }
                        }

                    }
                }
                else
                {
                    if (companies[0].ContainerManagementName != null && !companies[0].ContainerManagementName.Equals(string.Empty))
                    {
                        string jsonString;
                        string dataUrl = cmServer + "firma/" + companies[0].ContainerManagementName;

                        if (companies.Count() == 1)
                        {
                            // Single item
                            if (dataAction != Actions.Insert)
                            {
                                dataUrl += "/" + companies[0].CompanyID.ToString();
                            }

                            Firma firma = new Firma();

                            firma.ID = companies[0].CompanyID;
                            firma.Name = companies[0].NameVisible;

                            jsonString = firma.ToJson();
                        }
                        else
                        {
                            // All items
                            List<Firma> listFirma = new List<Firma>();
                            foreach (GetCompanyContainerManagement_Result company in companies)
                            {
                                Firma firma = new Firma();

                                firma.ID = company.CompanyID;
                                firma.Name = company.NameVisible;

                                listFirma.Add(firma);
                            }
                            jsonString = listFirma.ToJson();
                            dataAction = Actions.Update;
                        }

                        if (dataAction == Actions.Insert)
                        {
                            response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Post, jsonString);
                        }
                        else if (dataAction == Actions.Update)
                        {
                            response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Put, jsonString);
                        }
                        else if (dataAction == Actions.Delete)
                        {
                            response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Delete, jsonString);
                        }
                    }
                }
            }

            string ret = string.Empty;
            if (response != null)
            {
                ret = (int)response.StatusCode + " - " + response.StatusCode;
            }
            return ret;
        }

        /// <summary>
        /// Insert, Update or delete trade data
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="tradeID"></param>
        /// <param name="dataAction"></param>
        /// <returns></returns>
        public string TradeData(int systemID, int bpID, int tradeID, int dataAction)
        {
            logger.InfoFormat("Enter TradeData with param systemID: {0}; bpID: {1}; tradeID: {2}; dataAction: {3}", systemID, bpID, tradeID, dataAction);
            HttpWebResponse response = null;
            ObjectResult<GetTradeContainerManagement_Result> result = entities.GetTradeContainerManagement(systemID, bpID, tradeID);
            GetTradeContainerManagement_Result[] trades = result.ToArray();
            if (trades.Count() > 0)
            {
                if (trades[0].ContainerManagementName != null && !trades[0].ContainerManagementName.Equals(string.Empty))
                {
                    string jsonString;
                    string dataUrl = cmServer + "gewerk/" + trades[0].ContainerManagementName;

                    if (trades.Count() == 1)
                    {
                        // Single item
                        if (dataAction != Actions.Insert)
                        {
                            dataUrl += "/" + trades[0].TradeID.ToString();
                        }

                        Gewerk gewerk = new Gewerk();

                        gewerk.ID = trades[0].TradeID;
                        gewerk.Bezeichnung = trades[0].NameVisible;

                        jsonString = gewerk.ToJson();
                    }
                    else
                    {
                        // All items
                        List<Gewerk> listGewerk = new List<Gewerk>();
                        foreach (GetTradeContainerManagement_Result trade in trades)
                        {
                            Gewerk gewerk = new Gewerk();

                            gewerk.ID = trade.TradeID;
                            gewerk.Bezeichnung = trade.NameVisible;

                            listGewerk.Add(gewerk);
                        }
                        jsonString = listGewerk.ToJson();
                        dataAction = Actions.Update;
                    }

                    if (dataAction == Actions.Insert)
                    {
                        response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Post, jsonString);
                    }
                    else if (dataAction == Actions.Update)
                    {
                        response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Put, jsonString);
                    }
                    else if (dataAction == Actions.Delete)
                    {
                        response = DoWebRequest(dataUrl, cmUser, cmPassword, HttpMethods.Delete, jsonString);
                    }
                }
            }

            string ret = string.Empty;
            if (response != null)
            {
                ret = (int)response.StatusCode + " - " + response.StatusCode;
            }
            return ret;
        }

        /// <summary>
        /// Execute web request, send JSON Object depending on method
        /// </summary>
        /// <param name="url"></param>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <param name="method"></param>
        /// <param name="dataJson"></param>
        /// <param name="response"></param>
        private HttpWebResponse DoWebRequest(string url, string username, string password, string method, string dataJson)
        {
            logger.InfoFormat("Enter DoWebRequest with params url: {0}; method: {1}; dataJson: {2}", url, method, dataJson);
            HttpWebResponse response = null;

            try
            {
                HttpWebRequest request = WebRequest.CreateHttp(url);

                string authInfo = username + ":" + password;
                authInfo = Convert.ToBase64String(Encoding.Default.GetBytes(authInfo));
                request.Headers["Authorization"] = "Basic " + authInfo;

                request.Method = method;
                request.AllowWriteStreamBuffering = false;
                request.ContentType = "application/json; charset=utf-8";
                request.Accept = "Accept=application/json";
                request.SendChunked = true;
                request.AllowWriteStreamBuffering = false;
                byte[] byteArray = Encoding.UTF8.GetBytes(dataJson);
                request.ContentLength = byteArray.Length;

                if (method.Equals(HttpMethods.Post) || method.Equals(HttpMethods.Put))
                {
                    Stream writer = request.GetRequestStream();
                    writer.Write(byteArray, 0, byteArray.Length);
                    writer.Close();

                    response = request.GetResponse() as HttpWebResponse;
                }
                else
                {
                    response = request.GetResponse() as HttpWebResponse;
                }
            }
            catch (WebException ex)
            {
                logger.Error("WebException: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner WebException: " + ex.InnerException.Message);
                }
                logger.Debug("WebException Details: \n" + ex);

                WebExceptionStatus status = ex.Status;
                if (status == WebExceptionStatus.ProtocolError)
                {
                    logger.Debug("The server returned protocol error ");
                    response = (HttpWebResponse)ex.Response;
                    logger.Debug((int)response.StatusCode + " - " + response.StatusCode);
                }
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

            return response;
        }
    }
}