<%@ Page Title="Evaluación inmuebles" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evaluacion.aspx.cs" Inherits="proyectos_evaluacion" %>
<%@ Register src="proyector.ascx" tagname="proyector" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        FullRowSelect("#<%=GDocumentos.ClientID%>");
        $('input[name$="CNo"]').change(function() {
            otr = $(this).attr("id").replace(/CNo/g, "CEstado");
            $("#" + otr).attr('checked', !$(this).is(':checked'));
        });
        $('input[name$="CEstado"]').change(function() {
            otr = $(this).attr("id").replace(/CEstado/g, "CNo");
            $("#" + otr).attr('checked', !$(this).is(':checked'));
        });
        $('span[id$="LConcepto"]').css({ cursor: "hand", cursor: "pointer" }).click(function() {
            otr = $(this).attr("id").replace(/LConcepto/g, "CEstado");
            $("#" + otr).attr('checked', !$("#" + otr).is(':checked'));
            $("#" + otr).change();
        });
        function Calcular() {

            pinicial = parseFloat($("#<%= TPInicial.ClientID %>").val().replace(/,/g, ""));
            area = parseFloat($("#<%= TAreaAfectada.ClientID %>").val().replace(/,/g, ""));
            pdotacion = parseFloat($("#<%= TPDotacion.ClientID%>").val().replace(/,/g, ""));

            if (isNaN(pinicial))
                pinicial = 0;
            if (isNaN(pdotacion))
                pdotacion = 0;
            if (isNaN(area))
                area = 0;
            area = area > 0 ? pinicial / area : 0;
            pinicial += pdotacion;

            $("#<%= LCostoIntervencion.ClientID %>").text(currencyFormatted(area.toString()));
            $("#<%= LPTotal.ClientID %>").text(currencyFormatted(pinicial.toString()));
        }
        // $("#<%= TPInicial.ClientID %>").change(Calcular).change();
        $("#<%= TAreaAfectada.ClientID %>").change(Calcular).change();
        $("#<%= TPDotacion.ClientID%>").change(Calcular).change();
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc1:proyector ID="UCProyecto" runat="server" />
    <asp:Panel runat="server" ID="PDatos" Visible="false">
    <asp:HiddenField runat="server" ID="HEvaluacion" />
        <table class="tabla">
            <tr>
                <td colspan="4" class="Titulo">Concepto</td>
            </tr>
            <tr>
            <td>
                Adecuación</td>
            <td>
                <asp:DropDownList ID="DAdecuacion" runat="server" DataSourceID="SAdecuacion" 
                    DataTextField="nombre" DataValueField="id" AutoPostBack="True" 
                    onselectedindexchanged="DAdecuacion_SelectedIndexChanged">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SAdecuacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=108 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:CheckBox ID="CDotacion" runat="server" Text="Dotación" AutoPostBack="True" 
                    oncheckedchanged="CDotacion_CheckedChanged" />
            </td>
            <td>
                &nbsp;
            </td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GReubicacion" runat="server" AutoGenerateColumns="False" Width="100%"
                        DataSourceID="SReubicacion" DataKeyNames="id,idreubicacion">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Sí">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CEstado" runat="server" Checked='<%# Eval("estado").ToString()=="1" %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="No">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CNo" runat="server" Checked='<%# Eval("estado").ToString()!="1" %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Concepto">
                                <ItemTemplate>
                                    <asp:Label runat="server" ID="LConcepto" Text='<%# Eval("nombre").ToString() %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SReubicacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="(SELECT shared.id AS id, shared.nombre AS nombre,reubicacion_evaluacion.id AS idreubicacion,reubicacion_evaluacion.estado AS estado FROM shared LEFT JOIN reubicacion_evaluacion ON (reubicacion_evaluacion.proyecto=@evaluacion AND reubicacion_evaluacion.reubicacion=shared.id) WHERE shared.nReservado=109 AND shared.szReservado IS NULL) UNION (SELECT 0 AS id,'VIABLE' AS nombre, 0 AS idreubicacion,(SELECT viable FROM evaluacion WHERE proyecto=@evaluacion) AS estado)" >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HEvaluacion" Name="evaluacion" PropertyName="Value" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>
                    Presupuesto</td>
                <td>
                    <asp:TextBox runat="server" CssClass="dinero" ID="TPInicial" ReadOnly="true"></asp:TextBox></td>
                <td>
                    Area afectada (m<sup>2</sup>)</td>
                <td>
                    <asp:TextBox runat="server" CssClass="float" ID="TAreaAfectada"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    Costo intervención (m<sup>2</sup>)</td>
                <td align="right">
                    <asp:Label ID="LCostoIntervencion" runat="server" Text=""></asp:Label></td>
                <td>
                    Presupuesto de dotación</td>
                <td>
                    <asp:TextBox runat="server" CssClass="dinero" ID="TPDotacion"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    Presupuesto total</td>
                <td align="right">
                    <asp:Label ID="LPTotal" runat="server" Text=""></asp:Label></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>
                    Objeto</td>
                <td colspan="3">
                    <asp:Label ID="LObjeto" runat="server"></asp:Label>
                    </td>
            </tr>
            <tr>
                <td>Observaciones</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TObservaciones" Width="99%" TextMode="MultiLine"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Condiciones actuales</td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Afectaciones</td>
            </tr>
            <tr>
                <td>Naturales</td>
                <td><asp:DropDownList ID="DNaturales" runat="server" DataSourceID="SNaturales" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SNaturales" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=110 AND szReservado IS NULL ORDER BY nombre" >
            </asp:SqlDataSource></td>
                <td>Altura máxima de inundación sobre el piso</td>
                <td><asp:TextBox runat="server" ID="TAltura" CssClass="entero"></asp:TextBox>cm</td>
            </tr>
            <tr>
                <td>
                    Otros</td>
                <td>
                    <asp:TextBox ID="TOtros" runat="server"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Condiciones climaticas</td>
            </tr>
            <tr>
                <td>Clima</td>
                <td><asp:DropDownList ID="DClima" runat="server" DataSourceID="SClima" DataTextField="nombre" DataValueField="id">
            </asp:DropDownList>
            <asp:SqlDataSource ID="SClima" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=111 AND szReservado IS NULL ORDER BY nombre" >
        </asp:SqlDataSource></td>
                <td>Ambiente</td>
                <td><asp:DropDownList ID="DAmbiente" runat="server" DataSourceID="SAmbiente" DataTextField="nombre" DataValueField="id">
            </asp:DropDownList>
            <asp:SqlDataSource ID="SAmbiente" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=112 AND szReservado IS NULL ORDER BY nombre" >
        </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Temperatura promedio</td>
                <td><asp:TextBox runat="server" CssClass="entero" ID="TTemperatura"></asp:TextBox>&deg;C</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Acceso</td>
            </tr>
            <tr>
                <td>Acceso</td>
                <td><asp:DropDownList ID="DAcceso" runat="server" DataSourceID="SAcceso" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SAcceso" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=113 AND szReservado IS NULL ORDER BY nombre" >
            </asp:SqlDataSource></td>
                <td>Dificultad de acceso</td>
                <td><asp:DropDownList ID="DDificultadAcceso" runat="server" DataSourceID="SDificultadaAcceso" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SDificultadaAcceso" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=114 AND szReservado IS NULL ORDER BY nombre" >
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>
                    Acceso</td>
                <td>
                    <asp:DropDownList ID="DAcceso2" runat="server" DataSourceID="SAcceso" 
                        DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                    </asp:DropDownList><asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ErrorMessage="Por favor seleccione un acceso diferente." SetFocusOnError="true"
                        ControlToCompare="DAcceso" Operator="NotEqual" ControlToValidate="DAcceso2" Display="Dynamic">*</asp:CompareValidator>
                </td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Datos juridicos</td>
            </tr>
            <tr>
                <td>Tenencia</td>
                <td><asp:DropDownList ID="DTenencia" runat="server" DataSourceID="STenencia" DataTextField="nombre" DataValueField="id">
            </asp:DropDownList>
            <asp:SqlDataSource ID="STenencia" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=115 AND szReservado IS NULL ORDER BY nombre" >
        </asp:SqlDataSource></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>Cedula catastral</td>
                <td><asp:TextBox runat="server" ID="TCCatastral"></asp:TextBox></td>
                <td>Matricula inmobiliaria</td>
                <td><asp:TextBox runat="server" ID="TMatriculaI"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Áreas</td>
            </tr>
            <tr>
                <td>Total lote</td>
                <td><asp:TextBox runat="server" CssClass="float" ID="TATotal"></asp:TextBox>m<sup>2</sup></td>
                <td>Ocupada lote</td>
                <td><asp:TextBox runat="server" CssClass="float" ID="TAOcupada"></asp:TextBox>m<sup>2</sup></td>
            </tr>
            <tr>
                <td>Construida</td>
                <td><asp:TextBox runat="server" CssClass="float" ID="TAConstruida"></asp:TextBox>m<sup>2</sup></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Terreno</td>
            </tr>
            <tr>
                <td>Topografía</td>
                <td><asp:DropDownList ID="DTopografia" runat="server" DataSourceID="STopografia" DataTextField="nombre" DataValueField="id">
            </asp:DropDownList>
            <asp:SqlDataSource ID="STopografia" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=116 AND szReservado IS NULL ORDER BY nombre" >
        </asp:SqlDataSource></td>
                <td>Forma</td>
                <td><asp:DropDownList ID="DForma" runat="server" DataSourceID="SForma" DataTextField="nombre" DataValueField="id">
            </asp:DropDownList>
            <asp:SqlDataSource ID="SForma" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=117 AND szReservado IS NULL ORDER BY nombre" >
        </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Edificios</td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td><asp:CheckBox ID="CEnUso" runat="server" Text="Actualmente en uso" /></td>
                <td>Número de edificios</td>
                <td><asp:TextBox runat="server" CssClass="entero" ID="TEdificios"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    Número de pisos</td>
                <td><asp:TextBox runat="server" CssClass="entero" ID="TPisos"></asp:TextBox></td>
                <td>&nbsp;</td>
                <td><asp:CheckBox ID="CSotano" runat="server" Text="Sotano" /></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Exteriores</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GExteriores" runat="server" AutoGenerateColumns="False" 
                        DataSourceID="Sexteriores" DataKeyNames="id,idexteriores">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:BoundField HeaderText="Tipo" DataField="nombre" />
                            <asp:TemplateField HeaderText="Material">
                                <ItemTemplate>
                                    <asp:TextBox runat="server" ID="TMaterial" Text='<%# Bind("material") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Estado">
                                <ItemTemplate>
                                    <asp:DropDownList ID="DEstado" runat="server" DataSourceID="SEstado" DataTextField="nombre" DataValueField="id" SelectedValue='<%# Bind("estado") %>' AppendDataBoundItems="true">
                                        <asp:ListItem Text="(No definido)" Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SEstado" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=119 AND szReservado IS NULL ORDER BY nombre" >
                                </asp:SqlDataSource>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SExteriores" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT shared.id AS id, shared.nombre AS nombre,exteriores_evaluacion.id AS idexteriores,exteriores_evaluacion.estado AS estado,exteriores_evaluacion.material AS material FROM shared LEFT JOIN exteriores_evaluacion ON (exteriores_evaluacion.proyecto=@evaluacion AND exteriores_evaluacion.tipo=shared.id) WHERE shared.nReservado=118 AND shared.szReservado IS NULL" >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HEvaluacion" Name="evaluacion" PropertyName="Value" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="Titulo" colspan="4">
                    Documentos</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GDocumentos" runat="server" AutoGenerateColumns="False" 
                    DataSourceID="SDocumentos" DataKeyNames="id,iddocumento" 
                        onselectedindexchanged="GDocumentos_SelectedIndexChanged">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:ImageButton ID="ISelecccionar" Visible='<%# Eval("estado").ToString()=="1" %>' runat="server" CausesValidation="False" CommandName="Select" ImageUrl="~/imgs/edit.gif" Text="Seleccionar" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:ImageButton ID="IDelete" Visible='<%# Eval("estado").ToString()=="1" %>' runat="server" CausesValidation="False" CommandName="Delete" ImageUrl="~/imgs/eliminar.gif" Text="Eliminar" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Documento" DataField="nombre" />
                        <asp:TemplateField HeaderText="Archivo">
                            <ItemTemplate>
                                <asp:FileUpload ID="FArchivo" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SDocumentos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT shared.id AS id, shared.nombre AS nombre,documentos_proyecto.id AS iddocumento,LENGTH(documentos_proyecto.archivo)>0 AS estado 
                            FROM shared 
                            LEFT JOIN documentos_proyecto ON (documentos_proyecto.proyecto=@proyecto AND documentos_proyecto.documento=shared.id) 
                            WHERE shared.nReservado=106 AND (shared.szReservado IS NULL OR shared.szReservado!=-1)
                            AND (shared.parametro1=@tipo OR (@dotacion=1 AND shared.parametro1 IS NULL))
                            ORDER BY nombre" 
                DeleteCommand="DELETE FROM documentos_proyecto WHERE id=@iddocumento">
                <SelectParameters>
                    <asp:ControlParameter ControlID="HEvaluacion" Name="proyecto" PropertyName="Value" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DAdecuacion" Name="tipo" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="CDotacion" Name="dotacion" PropertyName="Checked" />
                </SelectParameters>
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Observaciones</td>
                <td colspan="3">
                <asp:TextBox ID="TObservacionesFinal" Width="99%" runat="server" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
        </table>
    <div style="text-align: right;">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <asp:Button runat="server" ID="BAceptar" Text="Aceptar" 
            onclick="BAceptar_Click" /><asp:Button runat="server" ID="BCancelar" 
            Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
    </div>
    </asp:Panel> 
</asp:Content>

