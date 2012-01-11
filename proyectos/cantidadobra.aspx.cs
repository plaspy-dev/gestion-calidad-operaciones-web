using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Collections;
using System.IO;
using SDG.Componentes;
using System.Globalization;
using MySql.Data.MySqlClient;

public partial class proyectos_cantidadobra : System.Web.UI.Page
{
    public class Elemento {

        public string hid;
        public string vu;
        public string vt;
        public string ca;
        public string ob;
        public string el;

        public Elemento(Repeater rep, int pos) {

            el = "";
            if (((Panel)rep.Items[pos].FindControl("S")).Visible == false) 
                return;

            hid = ((HiddenField)rep.Items[pos].FindControl("HC")).Value;
            vu = ((TextBox)rep.Items[pos].FindControl("TU")).Text;
            vt = ((TextBox)rep.Items[pos].FindControl("TT")).Text;
            ca = ((TextBox)rep.Items[pos].FindControl("TC")).Text;
            ob = ((TextBox)rep.Items[pos].FindControl("TO")).Text;
            el = ((HiddenField)rep.Items[pos].FindControl("HE")).Value;
        }
        public bool Restore(RepeaterItemEventArgs rep) {

            if (el == "" || el != ((HiddenField)rep.Item.FindControl("HE")).Value)
                return false;

            ((TextBox)rep.Item.FindControl("TU")).Text= vu;
            ((TextBox)rep.Item.FindControl("TT")).Text = vt;
            ((TextBox)rep.Item.FindControl("TC")).Text=ca;
            ((TextBox)rep.Item.FindControl("TO")).Text = ob;

            return true;
        }
        
        public bool Query(CConector conector, string proyecto) {

            if (el == "") // es un separador
                return true;

            Query query = new Query("cantidades_obra");

            query["vunitario"] = vu.Replace(",", "");
            query["vtotal"] = vt.Replace(",", "");
            query["cantidad"] = ca;
            query["observaciones"] = ob;

            if (hid.Length == 0)
            {
                if (vu.Length == 0 && vt.Length == 0 && ca.Length == 0 && ob.Length == 0) // no lo insertamos porque esta en blanco
                    return true;

                query["proyecto"] = proyecto;
                query["elemento"] = el;

                if (conector.QueryMod(query.GetInsert()) == -1)
                    return false;
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id='" + hid + "'")) == -1)
                    return false;
            }
            return true;
        }
    }

    public class Elementos {

        ArrayList elementos;
        public Elementos(Repeater RElementos)
        {
            Guardar(RElementos);
        }
        public void Guardar(Repeater RElementos) {

            if (!RElementos.Visible)
                return;
            elementos = new ArrayList();
            for (int i = 0; i < RElementos.Items.Count; i++)
            {
                Repeater rep = (Repeater)RElementos.Items[i].FindControl("R");
                for (int j = 0; j < rep.Items.Count; j++)
                {
                    elementos.Add(new Elemento(rep, j));
                }
            }
        }
        public void Restore(RepeaterItemEventArgs rep)
        {
            if (((Panel)rep.Item.FindControl("S")).Visible == false)
                return;
            Elemento el = null;
            if (elementos.Count > rep.Item.ItemIndex) // intentamos restaurar con la misma posicion de otra forma probamos en el arreglo
            {
                el = (Elemento)elementos[rep.Item.ItemIndex];
                if (el.Restore(rep))
                    return;
            }
            for (int k = 0; k < elementos.Count; k++)
            {
                el = (Elemento)elementos[k];
                if (el.Restore(rep))
                    break;
            }
        }
        public bool Querys(CConector conector,string proyecto) {

            for (int i = 0; i < elementos.Count; i++ ) {
                if (!((Elemento)elementos[i]).Query(conector, proyecto))
                    return false;
            }
            return true;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (Request.QueryString["idp"] != null)
        {
            ((MasterPageI)Master).SetParametros("?idp=" + Request.QueryString["idp"]);
        }
        if (!IsPostBack)
        {
            Session["Elementos"] = new Hashtable();
            if (Request.QueryString["idp"] != null)
            {
                ((MasterPageI)Master).SetModificacion(Request.QueryString["idp"]);

                Usuario usuario = Usuario.GetUsuario();
                CConector conector = new CConector();

                UCProyecto.IdProyecto = Request.QueryString["idp"];
                if (UCProyecto.IdProyecto.Length > 0)
                {
                    BAceptar.Enabled = usuario.CanInsert();
                    PDatos.Visible = true;
                    string total= conector.QueryString("SELECT SUM(vtotal) FROM cantidades_obra WHERE proyecto=" + UCProyecto.IdProyecto + ";");
                    CultureInfo culture = new CultureInfo("en-US");
                    if (total.Length > 0)
                    {
                        LFiltro.Visible = true;
                        ((MasterPageI)Master).Imprimir("~/imprimir/cantidad.htm");
                        LTotal.Text = String.Format(culture, "{0:c}", Convert.ToDouble(total));
                    } else {
                        LFiltro.Visible = conector.QueryString("SELECT COUNT(*) FROM cantidades_obra WHERE proyecto=" + UCProyecto.IdProyecto + " AND (cantidad IS NOT NULL OR vunitario IS NOT NULL);") != "0";
                        LTotal.Text = String.Format(culture, "{0:c}", 0.0);
                    }
                }
                else
                {
                    return;
                }
            }
            if (Request.QueryString["p"] == "1")
            {
                RFiltrar.Visible = true;
                RFiltrar.DataBind();
            }
        }
    }

    protected void LCapitulo_Click(object sender, EventArgs e) {

        if (HSel.Value != "") {
            Hashtable tabla = (Hashtable)Session["Elementos"];
            tabla[HSel.Value] = new Elementos(E);
        }
        if (HSel.Value == ((LinkButton)sender).CommandArgument)
            HSel.Value = "";
        else HSel.Value = ((LinkButton)sender).CommandArgument;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        CConector conector = new CConector();
        if (E.Visible)
        {
            Hashtable tabla = (Hashtable)Session["Elementos"];
            if (HSel.Value != "")
            {
                tabla[HSel.Value] = new Elementos(E);
            }
            foreach (DictionaryEntry elemento in tabla)
            {
                if (!((Elementos)elemento.Value).Querys(conector, UCProyecto.IdProyecto))
                    return;
            }
        }
        else
        {
            for (int i = 0; i < RFiltrar.Items.Count; i++)
            {
                Query query = new Query("cantidades_obra");
                HiddenField hid = (HiddenField)RFiltrar.Items[i].FindControl("HC");

                query["vunitario"] = ((TextBox)RFiltrar.Items[i].FindControl("TU")).Text.Replace(",", "");
                query["vtotal"] = ((TextBox)RFiltrar.Items[i].FindControl("TT")).Text.Replace(",", "");
                query["cantidad"] = ((TextBox)RFiltrar.Items[i].FindControl("TC")).Text;
                query["observaciones"] = ((TextBox)RFiltrar.Items[i].FindControl("TO")).Text;

                if (hid.Value.Length == 0)
                {
                    query["proyecto"] = UCProyecto.IdProyecto;
                    query["elemento"] = ((HiddenField)RFiltrar.Items[i].FindControl("HE")).Value;

                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
                else
                {
                    if (conector.QueryMod(query.GetUpdate("id='" + hid.Value + "'")) == -1)
                        return;
                }
            }
        }
        if (conector.QueryMod("UPDATE evaluacion SET presupuesto_inicial=(SELECT SUM(vtotal) FROM cantidades_obra WHERE proyecto=" + UCProyecto.IdProyecto + ") WHERE proyecto=" + UCProyecto.IdProyecto + ";") == -1)
            return;
        if (conector.InsertModificacionWeb(UCProyecto.IdProyecto) == -1)
            return;
        ((MasterPageI)Master).SetParametros("?idp=" + UCProyecto.IdProyecto);
        ((MasterPageI)Master).SetResultado(UCProyecto.Institucion + " modificado");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void R_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Hashtable tabla = (Hashtable)Session["Elementos"];
        Elementos elementos = (Elementos)tabla[HSel.Value];
        if (elementos != null)
        {
            elementos.Restore(e);
        }   
    }
    protected void LFiltro_Click(object sender, EventArgs e)
    {
        RFiltrar.Visible = !RFiltrar.Visible;
        E.Visible = !E.Visible;
        LFiltro.Text = E.Visible ? "Filtrar" : "Mostrar todo";
        if (RFiltrar.Visible)
        {
            LFiltro.OnClientClick = "return confirm('Esta acción revertira todos los cambios realizados. ¿Desea continuar?');";
        } 
        else
        {
            Hashtable tabla = (Hashtable)Session["Elementos"];
            LFiltro.OnClientClick = tabla.Count>0 ? "return confirm('Esta acción revertira todos los cambios realizados. ¿Desea continuar?');" : "";
        }
    }
    protected void OnImprimir(object sender, EventArgs e) {

        string resultado = (string)sender;
        // aqui modificamos el resultado
        string valor = "<table border=0 cellpadding=0 cellspacing=0 width=100% style='border-collapse: collapse;width:100%'>"
                + "<tr class=xl115 style='text-align:center'>"
                    + "<td style='font-weight: bold'>Descripción</td>"
                    + "<td style='font-weight: bold'>Unidad</td>"
                    + "<td style='font-weight: bold'>Cantidad</td>"
                    + "<td style='font-weight: bold'>Vr. unitario</td>"
                    + "<td style='font-weight: bold'>Vr. total</td>"
                    + "<td style='font-weight: bold'>Observaciones</td>"
                + "</tr>";

        CultureInfo culture = new CultureInfo("en-US");

        for (int i = 0; i < RFiltrar.Items.Count; i++)
        {
            valor += "<tr><td class='nowrap'><b>";
            valor+= ((Label)RFiltrar.Items[i].FindControl("LC")).Text;
            valor += "</b>";
            valor += ((Label)RFiltrar.Items[i].FindControl("LN")).Text;
            valor += "</td><td>";
            valor += ((Label)RFiltrar.Items[i].FindControl("LD")).Text;
            valor += "</td>";
            string sv= ((TextBox)RFiltrar.Items[i].FindControl("TC")).Text;
            double dv = string.IsNullOrEmpty(sv) ? 0 : Convert.ToDouble(sv, culture.NumberFormat);
            valor += "<td align=right>" + string.Format("{0:N}", dv);

            sv= ((TextBox)RFiltrar.Items[i].FindControl("TU")).Text;
            dv = string.IsNullOrEmpty(sv) ? 0 : Convert.ToDouble(sv, culture.NumberFormat);
            valor += "</td><td align=right>" + string.Format("{0:c}", dv);

            sv=((TextBox)RFiltrar.Items[i].FindControl("TT")).Text;
            dv = string.IsNullOrEmpty(sv) ? 0 : Convert.ToDouble(sv, culture.NumberFormat);
            valor += "</td><td align=right>" + string.Format("{0:c}", dv);
            string ob= ((TextBox)RFiltrar.Items[i].FindControl("TO")).Text;
            if (ob.Length == 0)
                ob = " ";
            valor += "</td><td class='nowrap'>" + ob;
            valor += "</td></tr>";
        }
        valor = valor.Replace("<td", "<td style='border: 1px solid #000;vertical-align:middle;'");
        valor += "</table>";
        resultado= resultado.Replace("$RFiltrar$", valor);


        Query query = new Query("proyecto");

        query["DDepartamento"] = "departamento.nombre";
        query["LGrupo"] = "departamento.descripcion";
        query["TSede"] = "proyecto.ips";
        query["DMunicipio"] = "municipio.nombre";
        query["TFVisita"] = "proyecto.visita";
        query["TObjeto"] = "REPLACE(intervencion.descripcion,'{0}',institucion.nombre)";
        query["sCoordinador"] = "REPLACE(grupo.descripcion,'\\\\n', '<br/>')";

        CConector conector = new CConector();

        MySqlDataReader reader = conector.Query(query.GetSelect("proyecto.id=" + UCProyecto.IdProyecto
            , "LEFT JOIN shared AS departamento ON (departamento.id=proyecto.departamento)"
            + " LEFT JOIN shared AS municipio ON (municipio.id=proyecto.municipio)"
            + " LEFT JOIN evaluacion ON (evaluacion.proyecto=proyecto.id)"
            + " LEFT JOIN shared AS intervencion ON (intervencion.id=evaluacion.adecuacion)"
            + " LEFT JOIN shared AS institucion ON (institucion.id=proyecto.tinstitucion)"
            +" LEFT JOIN shared AS grupo ON (grupo.nReservado=100 AND grupo.nombre=departamento.descripcion) "
            ));
        if (reader != null)
        {

            bool l = reader.Read();
            if (l)
            {
                resultado = resultado.Replace("$TFVisita$", CConector.GetFromMySQLDate(reader["TFVisita"]));
            }
            for (int i = 0; i < reader.FieldCount; i++)
            {
                resultado = resultado.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }


        Response.Clear();
        Response.Write(resultado);
        Response.End();
    }
}
