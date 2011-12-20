using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Globalization;
using MySql.Data.MySqlClient;

public partial class proyectos_evaluacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (Request.QueryString["idp"] != null)
        {
            ((MasterPageI)Master).SetParametros("?idp=" + Request.QueryString["idp"]);
        }

        if(!IsPostBack) {

            BAceptar.Enabled = false;

            if(Request.QueryString["idp"]!=null) {

                ((MasterPageI)Master).SetModificacion(Request.QueryString["idp"]);
                Usuario usuario = Usuario.GetUsuario();
                CConector conector = new CConector();

                UCProyecto.IdProyecto = Request.QueryString["idp"];
                if (UCProyecto.IdProyecto.Length > 0)
                {
                    BAceptar.Enabled = usuario.CanInsert();
                    PDatos.Visible = true;
                }
                else
                {
                    return;
                }

                Query query = new Query("evaluacion");

                query += "proyecto";
                query += "adecuacion";
                query += "afectacion_natural";
                query += "altura";
                query += "clima";
                query += "ambiente";
                query += "temperatura";
                query += "acceso";
                query += "acceso2";
                query += "dificultad_acceso";
                query += "tenencia";
                query += "cedula_catastral";
                query += "matricula_inmobiliaria";
                query += "area_total";
                query += "area_ocupada";
                query += "area_construida";
                query += "topografia";
                query += "forma";
                query += "actualmente_enuso";
                query += "edificios";
                query += "pisos";
                query += "sotano";
                query += "observaciones";
                query += "observacionesf";
                query += "otros";
                query += "viable";
                query += "objeto";
                query += "presupuesto_inicial";
                query += "area_afectada";
                query += "presupuesto_dotacion";

                MySqlDataReader reader = conector.Query(query.GetSelect("proyecto='" + Request.QueryString["idp"] + "'"));
                if(reader!=null && reader.Read()) {

                    ((MasterPageI)Master).Imprimir("~/imprimir/evaluacion.htm");

                    BAceptar.Enabled = usuario.CanUpdate();
                    HEvaluacion.Value = reader["proyecto"].ToString();
                    DAdecuacion.SelectedValue = reader["adecuacion"].ToString();
                    TObservaciones.Text = reader["observaciones"].ToString();
                    DNaturales.SelectedValue = reader["afectacion_natural"].ToString();
                    TAltura.Text = reader["altura"].ToString();
                    DClima.SelectedValue = reader["clima"].ToString();
                    DAmbiente.SelectedValue = reader["ambiente"].ToString();
                    TTemperatura.Text = reader["temperatura"].ToString();
                    DAcceso.SelectedValue = reader["acceso"].ToString();
                    DAcceso2.SelectedValue = reader["acceso2"].ToString();
                    DDificultadAcceso.Text = reader["dificultad_acceso"].ToString();
                    DTenencia.Text = reader["tenencia"].ToString();
                    TCCatastral.Text = reader["cedula_catastral"].ToString();
                    TMatriculaI.Text = reader["matricula_inmobiliaria"].ToString();
                    TATotal.Text = reader["area_total"].ToString();
                    TAOcupada.Text = reader["area_ocupada"].ToString();
                    TAConstruida.Text = reader["area_construida"].ToString();
                    DTopografia.SelectedValue = reader["topografia"].ToString();
                    DForma.SelectedValue = reader["forma"].ToString();
                    CEnUso.Checked = reader["actualmente_enuso"].ToString()=="1";
                    TEdificios.Text = reader["edificios"].ToString();
                    TPisos.Text = reader["pisos"].ToString();
                    CSotano.Checked = reader["sotano"].ToString()=="1";
                    TObservacionesFinal.Text = reader["observacionesf"].ToString();
                    TOtros.Text = reader["otros"].ToString();
                    TPInicial.Text = reader["presupuesto_inicial"].ToString().Replace(",", ".");
                    TAreaAfectada.Text = reader["area_afectada"].ToString().Replace(",", ".");
                    TPDotacion.Text = reader["presupuesto_dotacion"].ToString().Replace(",", ".");
                    TObjeto.Text = reader["objeto"].ToString();
                    CViable.Checked = reader["viable"].ToString() == "1";
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("evaluacion");
        CConector conector = new CConector();

        query["adecuacion"] = DAdecuacion.SelectedValue;
        query["afectacion_natural"] = DNaturales.SelectedValue;
        query["altura"] = TAltura.Text;
        query["clima"] = DClima.SelectedValue;
        query["ambiente"] = DAmbiente.SelectedValue;
        query["temperatura"] = TTemperatura.Text;
        query["acceso"] = DAcceso.SelectedValue;
        query["acceso2"] = DAcceso2.SelectedValue;
        query["dificultad_acceso"] = DDificultadAcceso.SelectedValue;
        query["tenencia"] = DTenencia.SelectedValue;
        query["cedula_catastral"] = TCCatastral.Text;
        query["matricula_inmobiliaria"] = TMatriculaI.Text;
        query["area_total"] = TATotal.Text;
        query["area_ocupada"] = TAOcupada.Text;
        query["area_construida"] = TAConstruida.Text;
        query["topografia"] = DTopografia.SelectedValue;
        query["forma"] = DForma.SelectedValue;
        query["actualmente_enuso"] = CEnUso.Checked ? "1" : "0";
        query["edificios"] = TEdificios.Text;
        query["pisos"] = TPisos.Text;
        query["sotano"] = CSotano.Checked ? "1" : "";
        query["observaciones"] = TObservaciones.Text;
        query["observacionesf"] = TObservacionesFinal.Text;
        query["otros"] = TOtros.Text;
        query["presupuesto_inicial"] = TPInicial.Text.Replace(",", "");
        query["area_afectada"] = TAreaAfectada.Text;
        query["presupuesto_dotacion"] = TPDotacion.Text.Replace(",", "");
        query["objeto"] = TObjeto.Text;
        query["viable"] = CViable.Checked ? "1" : "";
        
        if (HEvaluacion.Value.Length == 0)
        {
            query["proyecto"] = UCProyecto.IdProyecto;
            if(conector.QueryMod(query.GetInsert())==-1)
                return;
            HEvaluacion.Value = UCProyecto.IdProyecto;
        }
        else
        {
            if (conector.QueryMod(query.GetUpdate("proyecto='" + HEvaluacion.Value + "'")) == -1)
                return;
        }
        if (conector.InsertModificacionWeb(HEvaluacion.Value) == -1)
            return;

        for (int i = 0; i < GReubicacion.Rows.Count; i++)
        {
            Query reubicacion = new Query("reubicacion_evaluacion");
            reubicacion["reubicacion"] = GReubicacion.DataKeys[i].Values["id"].ToString();
            reubicacion["estado"] = ((CheckBox)GReubicacion.Rows[i].FindControl("CEstado")).Checked ? "1" : "0";

            string id = GReubicacion.DataKeys[i].Values["idreubicacion"].ToString();
            if (id.Length == 0)
            {
                reubicacion["proyecto"] = HEvaluacion.Value;
                if (conector.QueryMod(reubicacion.GetInsert()) == -1)
                    return;
            }
            else
            {
                if (conector.QueryMod(reubicacion.GetUpdate("id='" + id + "'")) == -1)
                    return;
            }
        }

        for (int i = 0; i < GExteriores.Rows.Count; i++)
        {
            Query exteriores = new Query("exteriores_evaluacion");

            exteriores["tipo"] = GExteriores.DataKeys[i].Values["id"].ToString();
            exteriores["material"] = ((TextBox)GExteriores.Rows[i].FindControl("TMaterial")).Text;
            exteriores["estado"] = ((DropDownList)GExteriores.Rows[i].FindControl("DEstado")).SelectedValue;

            string id = GExteriores.DataKeys[i].Values["idexteriores"].ToString();
            if (id.Length == 0)
            {
                exteriores["proyecto"] = HEvaluacion.Value;
                if (conector.QueryMod(exteriores.GetInsert()) == -1)
                    return;
            }
            else
            {
                if (conector.QueryMod(exteriores.GetUpdate("id='" + id + "'")) == -1)
                    return;
            }
        }
        
        ((MasterPageI)Master).SetResultado(UCProyecto.Institucion + " modificado");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void OnImprimir(object sender, EventArgs e)
    {

        string resultado = (string)sender;
        resultado = resultado.Replace("NoViable", CViable.Checked ? "" : "X");

        Query query = new Query("proyecto");

        query["DContrato"] = "CAST(CONCAT(LPAD(contratos.id,3,'0'),'-',shared.nombre,'-',entidades.nombre,'-',contratos.id,'-',contratos.ano) AS char)";
        query["DDepartamento"] = "departamento.nombre";
        query["LGrupo"] = "departamento.descripcion";
        query["TSede"] = "proyecto.ips";
        query["DMunicipio"] = "municipio.nombre";
        query["TFVisita"] = "proyecto.visita";
        query["OAMe"] = "IF(intervencion.nombre='ADECUACION MENOR', 'X', '')";
        query["OAMa"] = "IF(intervencion.nombre='ADECUACION MAYOR', 'X', '')";
        query["CDotacion"] = "IF(intervencion.nombre='DOTACION', 'X', '')";
        query["szReposicion"] = "''";

        CConector conector = new CConector();

        MySqlDataReader reader = conector.Query(query.GetSelect("proyecto.id=" + UCProyecto.IdProyecto
            , "LEFT JOIN shared AS departamento ON (departamento.id=proyecto.departamento)"
            +" LEFT JOIN contratos ON (contratos.id=proyecto.contrato)"
            + " LEFT JOIN shared ON (shared.id=contratos.unidad)"
            + " LEFT JOIN entidades ON (entidades.id=contratos.cliente)"
            +" LEFT JOIN shared AS municipio ON (municipio.id=proyecto.municipio)"
            + " LEFT JOIN shared AS intervencion ON (intervencion.id=proyecto.tintervencion)"
            ));
        if(reader!=null) {

            bool l= reader.Read();
            for(int i=0; i<reader.FieldCount; i++) {
                resultado= resultado.Replace(reader.GetName(i), l ? reader[i].ToString() : "");
            }
        }

        bool completa= conector.QueryString("SELECT COUNT(*)"
                            + " FROM shared "
                            +" LEFT JOIN proyecto ON (proyecto.id="
                            + UCProyecto.IdProyecto
                            +")"
                            +" LEFT JOIN documentos_proyecto ON (documentos_proyecto.proyecto=proyecto.id AND documentos_proyecto.documento=shared.id) "
                            +" WHERE shared.nReservado=106 AND shared.szReservado IS NULL "
                            +" AND (shared.parametro1=proyecto.tintervencion OR (proyecto.dotacion=1 AND shared.parametro1 IS NULL))"
                            +" AND documentos_proyecto.id IS NULL AND documentos_proyecto.archivo IS NULL;")=="0";

        resultado = resultado.Replace("szCompleta", completa ? "X" : "");
        resultado = resultado.Replace("szTramite", completa ? "" : "X");

        double pinicial = string.IsNullOrEmpty(TPInicial.Text) ? 0 : Convert.ToDouble(TPInicial.Text.Replace(",", ""));
        double area = string.IsNullOrEmpty(TAreaAfectada.Text) ? 0 : Convert.ToDouble(TAreaAfectada.Text.Replace(",", ""));
        double pdotacion = string.IsNullOrEmpty(TPDotacion.Text) ? 0 : Convert.ToDouble(TPDotacion.Text.Replace(",", ""));
        double total = pinicial + pdotacion;

        CultureInfo culture = new CultureInfo("en-US");

        resultado = resultado.Replace("szTotal", string.Format(culture, "{0:0,0.##}", total));
        resultado = resultado.Replace("pvalor", string.Format(culture, "{0:0,0.##}", total != 0 ? pinicial * 100 / total : 0));
        resultado = resultado.Replace("pdotacion", string.Format(culture, "{0:0,0.##}", total != 0 ? pdotacion * 100 / total : 0));
        resultado = resultado.Replace("szCostoIntervencion", string.Format(culture, "{0:0,0.##}", area != 0 ? total / area : 0));

        Response.Clear();
        Response.Write(resultado);
        Response.End();
    }
}
