using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InSite.App.Models.Interfaces
{
    public interface ISwitcher
    {
        bool TransferItem(int masterId, int itemId, bool select);
        Dictionary<int, string> GetDataSource(int masterId, bool showSelected);
        string GetCaption();
    }
}
