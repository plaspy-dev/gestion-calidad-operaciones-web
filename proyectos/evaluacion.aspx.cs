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
                // TPInicial.Text = conector.QueryString("SELECT SUM(cantidades_obra.vtotal)*(evaluacion.imprevistos+100)/100 FROM cantidades_obra LEFT JOIN evaluacion ON (evaluacion.proyecto=cantidades_obra.proyecto) WHERE cantidades_obra.proyecto=" + UCProyecto.IdProyecto + ";").Replace(",", ".");

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
                // query += "viable";
                query += "objeto";
                query += "presupuesto_inicial";
                query += "area_afectada";
                query += "presupuesto_dotacion";
                query += "dotacion";
                query += "estado";
                query += "tipo_nointervencion";
                query += "observaciones_nointervencion";

                MySqlDataReader reader = conector.Query(query.GetSelect("proyecto='" + UCProyecto.IdProyecto + "'"));
                if(reader!=null && reader.Read()) {

                    ((MasterPageI)Master).Imprimir("~/imprimir/evaluacion.htm");
                    HEvaluacion.Value = reader["proyecto"].ToString();
                    GDocumentos.Columns[1].Visible = ((CUsuario)usuario).CanDelete(HEvaluacion.Value);
                    BAceptar.Enabled = ((CUsuario)usuario).CanUpdate(HEvaluacion.Value);

                    conector.SelectInDropDown(DAdecuacion, reader["adecuacion"], "SELECT nombre FROM shared WHERE id={0}");
                    conector.SelectInDropDown(DNaturales,reader["afectacion_natural"]);
                    conector.SelectInDropDown(DClima, reader["clima"]);
                    conector.SelectInDropDown(DAmbiente, reader["ambiente"]);
                    conector.SelectInDropDown(DAcceso,reader["acceso"]);
                    conector.SelectInDropDown(DAcceso2,reader["acceso2"]);
                    conector.SelectInDropDown(DTopografia,reader["topografia"]);
                    conector.SelectInDropDown(DForma, reader["forma"]);
                    conector.SelectInDropDown(DEstado, reader["estado"].ToString());
                    conector.SelectInDropDown(DTipo, reader["tipo_nointervencion"]);
                    

                    TObservacionesConcepto.Text = reader["observaciones_nointervencion"].ToString();
                    CDotacion.Checked = reader["dotacion"].ToString() == "1";
                    TObservaciones.Text = reader["observaciones"].ToString();
                    TAltura.Text = reader["altura"].ToString();
                    TTemperatura.Text = reader["temperatura"].ToString();
                    
                    DDificultadAcceso.Text = reader["dificultad_acceso"].ToString();
                    DTenencia.Text = reader["tenencia"].ToString();
                    TCCatastral.Text = reader["cedula_catastral"].ToString();
                    TMatriculaI.Text = reader["matricula_inmobiliaria"].ToString();
                    TATotal.Text = reader["area_total"].ToString();
                    TAOcupada.Text = reader["area_ocupada"].ToString();
                    TAConstruida.Text = reader["area_construida"].ToString();
                    
                    CEnUso.Checked = reader["actualmente_enuso"].ToString()=="1";
                    TEdificios.Text = reader["edificios"].ToString();
                    TPisos.Text = reader["pisos"].ToString();
                    CSotano.Checked = reader["sotano"].ToString()=="1";
                    TObservacionesFinal.Text = reader["observacionesf"].ToString();
                    TOtros.Text = reader["otros"].ToString();
                    TAreaAfectada.Text = reader["area_afectada"].ToString().Replace(",", ".");
                    TPDotacion.Text = reader["presupuesto_dotacion"].ToString().Replace(",", ".");
                    TPInicial.Text = reader["presupuesto_inicial"].ToString().Replace(",", ".");
                    DAdecuacion_SelectedIndexChanged(sender, e);
                    // CViable.Checked = reader["viable"].ToString() == "1";
                }
                LEstado.Visible = false;
                if(HEvaluacion.Value.Length>0) {

                    LEstado.Visible = true;
                    string faltantes = conector.QueryString("SELECT COUNT(*)"
                            + " FROM shared "
                            + " LEFT JOIN evaluacion ON (evaluacion.proyecto="
                            + HEvaluacion.Value
                            + ")"
                            + " LEFT JOIN documentos_proyecto ON (documentos_proyecto.proyecto=evaluacion.proyecto AND documentos_proyecto.documento=shared.id) "
                            + " LEFT JOIN documentos_proyecto_archivo ON (documentos_proyecto_archivo.id=documentos_proyecto.id) "
                            + " WHERE shared.nReservado=106 AND shared.szReservado='1'"
                            + " AND (shared.parametro1=evaluacion.adecuacion OR (evaluacion.dotacion=1 AND shared.parametro1 IS NULL))"
                            + " AND (documentos_proyecto.id IS NULL OR documentos_proyecto_archivo.id IS NULL);");

                    if (faltantes != "0")
                    {
                        LEstado.Text = "Falta";
                        if (faltantes != "1")
                            LEstado.Text += "n";

                        LEstado.Text += " " + faltantes + "  documento";
                        if (faltantes != "1")
                            LEstado.Text += "s";
                        LEstado.BackColor = System.Drawing.Color.FromArgb(255, 0, 0);
                        LEstado.ForeColor = System.Drawing.Color.FromArgb(255, 255, 255);
                    }
                    else
                    {
                        LEstado.Text = "Documentación completa";
                        LEstado.BackColor = System.Drawing.Color.FromArgb(0, 255, 0);
                        LEstado.ForeColor = System.Drawing.Color.FromArgb(0, 0, 0);
                    }
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
        query["objeto"] = LObjeto.Text;
        query["dotacion"] = CDotacion.Checked ? "1" : "";
        query["estado"] = DEstado.SelectedValue;
        query["tipo_nointervencion"]= DTipo.SelectedIndex!=-1 ? DTipo.SelectedValue : "";
        query["observaciones_nointervencion"] = TObservacionesConcepto.Text;

        conector.StartTransaction();

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

        if (conector.QueryMod("DELETE FROM reubicacion_evaluacion WHERE proyecto='" + HEvaluacion.Value +"'")==-1)
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
        for (int i = 0; i < GDocumentos.Rows.Count; i++)
        {
            Query documentos = new Query("documentos_proyecto");
            
            string id = GDocumentos.DataKeys[i].Values["iddocumento"].ToString();
            FileUpload file = (FileUpload)GDocumentos.Rows[i].FindControl("FArchivo");

            documentos["observaciones"] = ((TextBox)GDocumentos.Rows[i].FindControl("TObservaciones")).Text;
            if (id.Length == 0)
            {
                if (((TextBox)GDocumentos.Rows[i].FindControl("TObservaciones")).Text.Length > 0 || file.HasFile)
                {
                    documentos["documento"] = GDocumentos.DataKeys[i].Value.ToString();
                    documentos["proyecto"] = UCProyecto.IdProyecto;
                    int res = conector.QueryMod(documentos.GetInsert());
                    if (res == -1)
                        return;
                    id= res.ToString();
                }
            }
            else
            {
                if (conector.QueryMod(documentos.GetUpdate("id='" + id + "'")) == -1)
                    return;
            }

            if (file.HasFile)
            {
                if (conector.QueryMod("DELETE FROM documentos_proyecto_archivo WHERE id='" + id + "'") == -1)
                    return;

                Query doc = new Query("documentos_proyecto_archivo");

                doc["id"] = id;

                Archivos archivo = new Archivos(file.PostedFile, 0);
                archivo.SaveFile(doc);
            }
        }
        conector.Commit();
        ((MasterPageI)Master).SetParametros("?idp=" + UCProyecto.IdProyecto);
        ((MasterPageI)Master).SetResultado(UCProyecto.Institucion + " modificado");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void GDocumentos_SelectedIndexChanged(object sender, EventArgs e)
    {
        Query archivos = new Query("documentos_proyecto_archivo");

        archivos += "id";
        archivos += "nombre";
        archivos += "tipo";

        Archivos archivo = new Archivos(archivos.GetSelect("id='" + GDocumentos.SelectedDataKey.Values["iddocumento"].ToString() + "'"),
            "SELECT archivo FROM documentos_proyecto_archivo WHERE id={0}");

        archivo.ShowFile(Response);
    }

    protected void OnImprimir(object sender, EventArgs e)
    {

        string resultado = (string)sender;

        resultado = resultado.Replace("$szAMenor$", DAdecuacion.SelectedItem.Text.ToLower()=="menor" ? "X" : "");
        resultado = resultado.Replace("$szAMayor$", DAdecuacion.SelectedItem.Text.ToLower() == "mayor" ? "X" : "");
        resultado = resultado.Replace("$sIntervencion$", DEstado.SelectedItem.Text.ToLower().IndexOf("no") == -1 ? "X" : "");
        resultado = resultado.Replace("$sNoIntervencion$", DEstado.SelectedItem.Text.ToLower().IndexOf("no") != -1 ? "X" : "");

        resultado = resultado.Replace("$sTipo$", DEstado.SelectedItem.Text.ToLower().IndexOf("no") == -1 ? DTipo.SelectedItem.Text : "");
        resultado = resultado.Replace("$sTipoNo$", DEstado.SelectedItem.Text.ToLower().IndexOf("no") != -1 ? DTipo.SelectedItem.Text : "");
        resultado = resultado.Replace("$sJustificacion$", TObservacionesConcepto.Text);

        Query query = new Query("proyecto");

        query["DDepartamento"] = "departamento.nombre";
        query["LGrupo"] = "departamento.descripcion";
        query["TSede"] = "proyecto.ips";
        query["DMunicipio"] = "municipio.nombre";
        query["TFVisita"] = "proyecto.visita";
        query["sCoordinador"] = "REPLACE(grupo.descripcion,'\\\\n', '<br/>')";
        query["sLocalidad"] = "proyecto.nombre_localidad";

        CConector conector = new CConector();

        MySqlDataReader reader = conector.Query(query.GetSelect("proyecto.id=" + UCProyecto.IdProyecto
            , "LEFT JOIN shared AS departamento ON (departamento.id=proyecto.departamento)"
            +" LEFT JOIN shared AS municipio ON (municipio.id=proyecto.municipio)"
            + " LEFT JOIN shared AS grupo ON (grupo.nReservado=100 AND grupo.nombre=departamento.descripcion) "
            ));
        if(reader!=null) {

            bool l= reader.Read();
            if(l) {
                resultado = resultado.Replace("$TFVisita$", CConector.GetFromMySQLDate(reader["TFVisita"]));
            }
            for(int i=0; i<reader.FieldCount; i++) {
                resultado= resultado.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }

        bool completa = conector.QueryString("SELECT COUNT(*)"
                            + " FROM shared "
                            + " LEFT JOIN evaluacion ON (evaluacion.proyecto="
                            + HEvaluacion.Value
                            + ")"
                            + " LEFT JOIN documentos_proyecto ON (documentos_proyecto.proyecto=evaluacion.proyecto AND documentos_proyecto.documento=shared.id) "
                            + " LEFT JOIN documentos_proyecto_archivo ON (documentos_proyecto_archivo.id=documentos_proyecto.id) "
                            + " WHERE shared.nReservado=106 AND shared.szReservado='1'"
                            + " AND (shared.parametro1=evaluacion.adecuacion OR (evaluacion.dotacion=1 AND shared.parametro1 IS NULL))"
                            + " AND (documentos_proyecto.id IS NULL OR documentos_proyecto_archivo.id IS NULL);") == "0";

        resultado = resultado.Replace("$szCompleta$", completa ? "X" : "");
        resultado = resultado.Replace("$szTramite$", completa ? "" : "X");

        CultureInfo culture = new CultureInfo("en-US");

        double pinicial = string.IsNullOrEmpty(TPInicial.Text) ? 0 : Convert.ToDouble(TPInicial.Text, culture.NumberFormat);
        double area = string.IsNullOrEmpty(TAreaAfectada.Text) ? 0 : Convert.ToDouble(TAreaAfectada.Text, culture.NumberFormat);
        double total = pinicial;
        double aiu = total * 0.32;
        total += aiu;

        resultado = resultado.Replace("$sTPInicial$", string.Format("{0:c}", pinicial));
        resultado = resultado.Replace("$sAIU$", string.Format("{0:c}", aiu));

        resultado = resultado.Replace("$szTotal$", string.Format("{0:c}", total));
        resultado = resultado.Replace("$pvalor$", string.Format("{0:N}", total != 0 ? pinicial * 100 / total : 0));
        resultado = resultado.Replace("$paiu$", string.Format("{0:N}", total != 0 ? aiu * 100 / total : 0));
        resultado = resultado.Replace("$szCostoIntervencion$", string.Format("{0:c}", area != 0 ? total / area : 0));

        Response.Clear();
        Response.Write(resultado);
        Response.End();
    }

    protected void DAdecuacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        CConector conector = new CConector();
        string institucion = conector.QueryString("SELECT shared.nombre FROM proyecto LEFT JOIN shared ON (shared.id=proyecto.tinstitucion) WHERE proyecto.id='" + UCProyecto.IdProyecto + "'");
        string objeto = conector.QueryString("SELECT descripcion FROM shared WHERE id='" + DAdecuacion.SelectedValue + "'");
        LObjeto.Text = string.Format(objeto, institucion);
    }
    protected void CDotacion_CheckedChanged(object sender, EventArgs e)
    {
        DAdecuacion_SelectedIndexChanged(sender, e);
    }
    protected void DEstado_SelectedIndexChanged(object sender, EventArgs e)
    {
        DTipo.DataBind();
        GReubicacion.DataBind();
    }
}
