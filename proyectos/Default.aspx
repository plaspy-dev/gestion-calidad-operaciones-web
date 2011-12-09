<%@ Page Title="Proyecto" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="proyectos_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        FullRowSelect("#<%=GDocumentos.ClientID%>");
        $("#<%= TNombre.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservice/proyecto.asmx/GetProyectos",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {
                $.goURL("idp=" + ui.item.value);
                return false;
            }
        });

        function currencyFormatted(amount) {
            var i = parseFloat(amount);
            if (isNaN(i)) { i = 0.00; }
            var minus = '';
            if (i < 0) { minus = '-'; }
            i = Math.abs(i);
            i = parseInt((i + .005) * 100);
            i = i / 100;
            s = new String(i);
            if (s.indexOf('.') < 0) { s += '.00'; }
            if (s.indexOf('.') == (s.length - 2)) { s += '0'; }
            s = minus + s;
            return '$' + commaFormatted(s);
        }

        function commaFormatted(amount) {

            var delimiter = ","; // replace comma if desired
            var a = amount.split('.', 2)
            var d = a[1];
            var i = parseInt(a[0]);
            if (isNaN(i)) { return ''; }
            var minus = '';
            if (i < 0) { minus = '-'; }
            i = Math.abs(i);
            var n = new String(i);
            var a = [];
            while (n.length > 3) {
                var nn = n.substr(n.length - 3);
                a.unshift(nn);
                n = n.substr(0, n.length - 3);
            }
            if (n.length > 0) { a.unshift(n); }
            n = a.join(delimiter);
            if (d.length < 1) { amount = n; }
            else { amount = n + '.' + d; }
            amount = minus + amount;
            return amount;
        }

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
        $("#<%= TPInicial.ClientID %>").change(Calcular).change();
        $("#<%= TAreaAfectada.ClientID %>").change(Calcular).change();
        $("#<%= TPDotacion.ClientID%>").change(Calcular).change();

        /*$("#<%= BCancelar.ClientID %>").unbind('click');
        $("#<%= BCancelar.ClientID %>").click(function() {
            alert($("#aspnetForm").attr("action"));
            $("#aspnetForm").attr("action", "<%=ResolveUrl("~/")%>imprimir/Default.aspx");
            $("#aspnetForm").attr("target", "_blank");
            $("#aspnetForm").submit();
            return false;
        });*/
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:HiddenField ID="HProyecto" runat="server" />
                <table style="width: 100%;">
                <tr>
                    <td>
                        Contrato</td>
                    <td>
                        <asp:DropDownList ID="DContrato" runat="server" DataSourceID="SContrato" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true" Width="200px">
                            <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SContrato" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT contratos.id, CAST(CONCAT(LPAD(contratos.id,3,'0'),'-',shared.nombre,'-',entidades.nombre,'-',contratos.id,'-',contratos.ano) AS char) AS nombre
                                            FROM contratos
                                            LEFT JOIN shared ON (shared.id=contratos.unidad)
                                            LEFT JOIN entidades ON (entidades.id=contratos.cliente)
                                            WHERE contratos.estado IS NULL ORDER BY id" >
                        </asp:SqlDataSource>
                        <asp:RequiredFieldValidator ControlToValidate="DContrato" ErrorMessage="Por favor seleccione un contrato." InitialValue="" ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                    <td>
                        Nombre</td>
                    <td>
                        <asp:TextBox runat="server" ID="TNombre"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                </tr>
                <tr>
                    <td>
                        Objeto</td>
                    <td colspan="3">
                        <asp:TextBox ID="TObjeto" runat="server" TextMode="MultiLine" Width="99%"></asp:TextBox>
                        </td>
                </tr>
                <tr>
                    <td>
                        Departamento</td>
                    <td>
                        <asp:DropDownList ID="DDepartamento" runat="server" 
                            DataSourceID="SDepartamento" DataTextField="nombre" DataValueField="id" 
                            AutoPostBack="true" onselectedindexchanged="DDepartamento_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDepartamento" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=101 AND szReservado IS NULL ORDER BY nombre" >
                    </asp:SqlDataSource>
                        <asp:Label ID="LGrupo" runat="server" Text=""></asp:Label></td>
                    <td>
                        &nbsp;</td>
                    <td>
                        <asp:CheckBox ID="CViable" runat="server" Text="Víable" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Municipio</td>
                    <td>
                        <asp:DropDownList ID="DMunicipio" runat="server" DataSourceID="SMunicipio" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SMunicipio" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared 
                            WHERE nReservado=102 AND szReservado IS NULL AND descripcion=@departamento ORDER BY nombre" >
                            <SelectParameters>
                            <asp:ControlParameter ControlID="DDepartamento" Name="departamento" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                    <td>
                        Localidad</td>
                    <td>
                        <asp:DropDownList ID="DLocalidad" runat="server" DataSourceID="SLocalidad" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SLocalidad" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=103 AND szReservado IS NULL" >
                        </asp:SqlDataSource></td>
                </tr>
                <tr>
                    <td>
                        Sede</td>
                    <td>
                        <asp:TextBox runat="server" ID="TSede"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="TSede" ErrorMessage="Por favor ingrese una sede." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                    <td>
                        IPS referencia</td>
                    <td>
                        <asp:TextBox ID="TIPS" runat="server"></asp:TextBox>
                        </td>
                </tr>
                <tr>
                    <td>
                        Dirección</td>
                    <td>
                        <asp:TextBox ID="TDireccion" runat="server"></asp:TextBox>
                        </td>
                    <td>
                        Teléfono</td>
                    <td>
                        <asp:TextBox ID="TTelefono" runat="server"></asp:TextBox>
                        </td>
                </tr>
                <tr>
                    <td>
                        Tipo de intervención</td>
                    <td>
                        <asp:DropDownList ID="DTIntervencion" runat="server" 
                            DataSourceID="STIntervencion" DataTextField="nombre" DataValueField="id" 
                            AutoPostBack="True">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STIntervencion" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=104 AND szReservado IS NULL" >
                    </asp:SqlDataSource></td>
                    <td>
                        &nbsp;</td>
                    <td>
                        <asp:CheckBox ID="CDotacion" runat="server" Text="Dotación" 
                            AutoPostBack="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Tipo de institución</td>
                    <td>
                        <asp:DropDownList ID="DTInstitucion" runat="server" DataSourceID="STInstitucion" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STInstitucion" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=105 AND szReservado IS NULL" >
                    </asp:SqlDataSource></td>
                    <td>
                        Fecha visita</td>
                    <td>
                        <asp:TextBox ID="TFVisita" runat="server" CssClass="fecha"></asp:TextBox>
                        <asp:RangeValidator ControlToValidate="TFVisita" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Presupuesto inicial</td>
                    <td>
                        <asp:TextBox runat="server" CssClass="dinero" ID="TPInicial"></asp:TextBox></td>
                    <td>
                        Area afectada (m2)</td>
                    <td>
                        <asp:TextBox runat="server" CssClass="float" ID="TAreaAfectada"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        Costo intervención (m2)</td>
                    <td align="right">
                        <asp:Label ID="LCostoIntervencion" runat="server" Text=""></asp:Label></td>
                    <td>
                        Presupuesto inicial de dotación</td>
                    <td>
                        <asp:TextBox runat="server" CssClass="dinero" ID="TPDotacion"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        Presupuesto Total</td>
                    <td align="right">
                        <asp:Label ID="LPTotal" runat="server" Text=""></asp:Label></td>
                    <td>
                        Código prestador</td>
                    <td>
                        <asp:TextBox ID="TPrestador" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones</td>
                    <td align="right" colspan="3">
                        <asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" 
                            Width="99%"></asp:TextBox></td>
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
                                WHERE shared.nReservado=106 AND shared.szReservado IS NULL 
                                AND (shared.parametro1=@tipo OR (@dotacion=1 AND shared.parametro1 IS NULL))
                                ORDER BY nombre" 
                    DeleteCommand="DELETE FROM documentos_proyecto WHERE id=@iddocumento">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HProyecto" Name="proyecto" PropertyName="Value" DefaultValue="0" />
                        <asp:ControlParameter ControlID="DTIntervencion" Name="tipo" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="CDotacion" Name="dotacion" PropertyName="Checked" />
                    </SelectParameters>
                </asp:SqlDataSource></td>
                </tr>
            </table>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" />
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="false" Text="Cancelar" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
</asp:Content>

