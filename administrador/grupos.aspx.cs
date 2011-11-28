using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class administrador_grupos : System.Web.UI.Page
{
    class Parents {
        public string parent {set; get; }
        public ArrayList permisos {set; get;}
        public Parents(string p) {
            parent = p;
            permisos = new ArrayList();
        }
        public Permisos FindURL(string url) {

            for (int i = 0; i < permisos.Count; i++)
            {
                if (((Permisos)permisos[i]).pagina == url)
                    return (Permisos)permisos[i];
            }
            return null;
        }
    }

    class Permisos
    {
        protected string _Pagina;
        protected string _Titulo;
        protected int permisos;
        
        public Permisos(string tit, string pag) {

            _Titulo = tit;
            _Pagina=pag;
            permisos = 0;
        }
        public Permisos(string tit, string pag, int per)
        {
            _Titulo = tit;
            _Pagina = pag;
            permisos = per;
        }
        public string titulo {
            get { return _Titulo; }
        }
        public string pagina {
            get { return _Pagina; }
        }
        public void SetPermisos(int per)
        {
            permisos = per;
        }
        public bool administrador {
            get { return (permisos&32)==32; }
        }
        public bool eliminar
        {
            get { return (permisos & 16) == 16; }
        }
        public bool edicion
        {
            get { return (permisos & 8) == 8; }
        }
        public bool insercion
        {
            get { return (permisos & 4) == 4; }
        }
        public bool imprimir
        {
            get { return (permisos & 2) == 2; }
        }
        public bool lectura
        {
            get { return (permisos & 1) == 1; }
        }
        public bool todos
        {
            get { return (permisos & 63) == 63; }
        }
    };

    protected void Page_Load(object sender, EventArgs e)
    {
        BEliminar.Visible = false;
        if(!IsPostBack) {

            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();

            TNombre.Focus();
            ArrayList parents= new ArrayList();
            ArrayList menu = Usuario.GetUsuario().GetFullMenu();
            for(int i=0; i<menu.Count; i++) {

                CURLs url = (CURLs)menu[i];
                if (url.m_bNativo)
                {
                    Parents padre=null;
                    for (int j = 0; j < parents.Count; j++ ) {
                        if(((Parents) parents[j]).parent==url.Parent) {
                            padre = (Parents)parents[j];
                            break;
                        }
                    }
                    if(padre==null) {
                        padre = new Parents(url.Parent);
                        parents.Add(padre);
                    }
                    padre.permisos.Add(new Permisos(url.Titulo, url.URL));
                }
            }
            RParents.DataSource = parents;
            RParents.DataBind();
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query= new Query("grupo");
        CConector conector = CConector.GetConector();
        string szQuery;
        string mensaje;
        string grupo = "";

        query["nombre"] = TNombre.Text;
        query["descripcion"] = TDescripcion.Text;

        if(LGrupos.SelectedIndex==-1) {

            szQuery = query.GetInsert();
            mensaje = TNombre.Text + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            grupo = resultado.ToString();
        } else {
            szQuery = query.GetUpdate("id='" + LGrupos.SelectedValue + "'");
            mensaje = TNombre.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
            grupo = LGrupos.SelectedValue;
        }
        if (conector.InsertModificacionWeb(grupo) == -1)
            return;
        if (conector.QueryMod("DELETE FROM permisosweb WHERE grupo='" + grupo + "'") == -1)
            return;

        for (int j = 0; j < RParents.Items.Count; j++)
        {
            GridView grid = (GridView)RParents.Items[j].FindControl("GPermisos");
            Query permisos = new Query("permisosweb");

            for (int i = 0; i < grid.Rows.Count; i++)
            {
                permisos["grupo"] = grupo;
                HiddenField pag = (HiddenField)grid.Rows[i].FindControl("pagina");
                permisos["url"] = pag.Value;
                int per = 0;

                CheckBox check;
                check = (CheckBox)grid.Rows[i].FindControl("a");
                if (check.Checked)
                    per += 32;
                check = (CheckBox)grid.Rows[i].FindControl("e");
                if (check.Checked)
                    per += 16;
                check = (CheckBox)grid.Rows[i].FindControl("d");
                if (check.Checked)
                    per += 8;
                check = (CheckBox)grid.Rows[i].FindControl("i");
                if (check.Checked)
                    per += 4;
                check = (CheckBox)grid.Rows[i].FindControl("m");
                if (check.Checked)
                    per += 2;
                check = (CheckBox)grid.Rows[i].FindControl("l");
                if (check.Checked)
                    per += 1;
                if (per == 0) // lo omitimos
                    continue;
                if (per > 0 && (per & 1) != 1)
                    per += 1;
                permisos["permiso"] = per.ToString();

                if (conector.QueryMod(permisos.GetInsert()) == -1)
                    return;
            }
        }

        ((MasterPageI)Master).SetResultado(mensaje);
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BEliminar_Click(object sender, EventArgs e)
    {
        CConector conector = CConector.GetConector();
        if (conector.QueryMod("DELETE FROM permisosweb WHERE grupo='" + LGrupos.SelectedValue + "'") == -1)
            return;
        if (conector.QueryMod("DELETE FROM grupo WHERE id='" + LGrupos.SelectedValue + "'") == -1)
            return;
        conector.InsertModificacionWeb(LGrupos.SelectedValue);
        ((MasterPageI)Master).SetResultado("Grupo " + TNombre.Text + " Eliminado.");
    }
    protected void LGrupos_SelectedIndexChanged(object sender, EventArgs e)
    {
        ArrayList parents = new ArrayList();
        ArrayList menu = Usuario.GetUsuario().GetFullMenu();

        for (int i = 0; i < menu.Count; i++)
        {

            CURLs url = (CURLs)menu[i];
            if (url.m_bNativo)
            {
                Parents padre = null;
                for (int j = 0; j < parents.Count; j++)
                {
                    if (((Parents)parents[j]).parent == url.Parent)
                    {
                        padre = (Parents)parents[j];
                        break;
                    }
                }
                if (padre == null)
                {
                    padre = new Parents(url.Parent);
                    parents.Add(padre);
                }
                padre.permisos.Add(new Permisos(url.Titulo, url.URL, LGrupos.SelectedValue == "0" ? 63 : 0));
            }
        }

        if (LGrupos.SelectedValue == "0")
        {
            BAceptar.Enabled = false;
            BEliminar.Enabled = false;

            TNombre.Text = LGrupos.SelectedItem.Text;
            TDescripcion.Text = "Grupo de administración, con todos los accesos";
        } else {
            Usuario usuario= Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanUpdate();
            BEliminar.Enabled = usuario.CanDelete();
            BEliminar.Visible = true;

            CConector conector= CConector.GetConector();

            TNombre.Text = LGrupos.SelectedItem.Text;
            TDescripcion.Text = conector.QueryString("SELECT descripcion FROM grupo WHERE id='" + LGrupos.SelectedValue + "'");

            Query query = new Query("permisosweb");
            query += "url";
            query += "permiso";

            MySqlDataReader reader= conector.Query(query.GetSelect("grupo='" + LGrupos.SelectedValue + "'"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    string url= reader["url"].ToString();
                    int nPermisos = Convert.ToInt32(reader["permiso"]);
                    for (int i = 0; i < parents.Count; i++)
                    {
                        Parents pagina = (Parents)parents[i];
                        Permisos info = pagina.FindURL(url);
                        if (info!=null)
                        {
                            info.SetPermisos(nPermisos);
                        }
                    }
                }
            }
        }
        RParents.DataSource = parents;
        RParents.DataBind();

        ((MasterPageI)Master).SetModificacion(LGrupos.SelectedValue);
    }

    protected void RParents_ItemCreated(object sender, RepeaterItemEventArgs e)
    {
        if(e.Item.DataItem!=null) {

            GridView grid = (GridView)e.Item.FindControl("GPermisos");
            grid.DataSource= ((Parents)e.Item.DataItem).permisos;
        }
    }
}
