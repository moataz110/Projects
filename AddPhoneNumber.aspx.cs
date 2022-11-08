using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace milestone_3
{
    public partial class AddPhoneNumber : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void add_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["GUC"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            int Id = Int16.Parse(id.Text);
            int phonee = Int16.Parse(phone.Text);
            SqlCommand addMobile = new SqlCommand("addMobile", conn);
            addMobile.CommandType = CommandType.StoredProcedure;
            addMobile.Parameters.Add(new SqlParameter("@ID", Id));
            addMobile.Parameters.Add(new SqlParameter("@mobile_number", phonee));

            conn.Open();
            addMobile.ExecuteNonQuery();
            conn.Close();


        }
    }
}