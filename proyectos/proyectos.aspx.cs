using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class proyectos_proyectos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            DDepartamento_SelectedIndexChanged(null, null);
        GResultados.AllowPaging = false;
        GResultados.DataBind();
        LTotal.Text = GResultados.Rows.Count + " Resultados";
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
        }
        GResultados.AllowPaging = true;
        GResultados.DataBind();
    }
    protected void DDepartamento_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DDepartamento.Items.Count == 0)
            DDepartamento.DataBind();
    }
}
