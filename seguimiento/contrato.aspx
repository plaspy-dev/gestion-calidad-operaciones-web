<%@ Page Title="Información general del contrato" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="contrato.aspx.cs" Inherits="seguimiento_contrato" %>
<%@ Register src="proyecto.ascx" tagname="proyecto" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        addDialog("#<%= PDatos.ClientID %>", "#dNivelEducativo");
        $("#<%= TRPropios.ClientID %>,#<%= TRColombiaH.ClientID %>,#<%= TROtras.ClientID %>,#<%= TAdicion.ClientID %>").change(function() {
            var p = parseFloat($("#<%= TRPropios.ClientID %>").val().replace(/,/g, ""));
            var c = parseFloat($("#<%= TRColombiaH.ClientID %>").val().replace(/,/g, ""));
            var o = parseFloat($("#<%= TROtras.ClientID %>").val().replace(/,/g, ""));
            if (isNaN(p))
                p = 0;
            if (isNaN(c))
                c = 0;
            if (isNaN(o))
                o = 0;
            var total = p + c + o;
            $("#<%= LTotalR.ClientID %>").text(currencyFormatted(total.toString()));
            // adiciones
            var a = parseFloat($("#<%= TAdicion.ClientID %>").val().replace(/,/g, ""));
            if (isNaN(a))
                a = 0;
            total += a;
            $("#<%= LTotalC.ClientID %>").text(currencyFormatted(total.toString()));
        }).change();

        function daysDiff(d1, d2) {
            var t2 = d2.getTime();
            var t1 = d1.getTime();

            return parseInt((t2 - t1) / (24 * 3600 * 1000));
        }
        function monthDiff(d1, d2) {
            var d1Y = d1.getFullYear();
            var d2Y = d2.getFullYear();
            var d1M = d1.getMonth();
            var d2M = d2.getMonth();

            return (d2M + 12 * d2Y) - (d1M + 12 * d1Y);
        }

        function calcularDuracion() {
            var f = $("#<%= TFinalizacion.ClientID %>").datepicker("getDate");
            var i = $("#<%= TActaInicio.ClientID %>").datepicker("getDate");
            if (f && i) {
                $("#<%= LDuracion.ClientID %>").html(monthDiff(i, f));
            } else {
                $("#<%= LDuracion.ClientID %>").html("");
            }
        }

        var tr = $("#<%= GFinanciero.ClientID %> tr");
        for (var i = 1; i < tr.length; i++) {
            var td = $(tr[i]).children("td");
            var pos = td.length - 5;
            if ($(td[pos]).text().indexOf(',') == -1) {
                $(td[pos]).text(currencyFormatted($(td[pos]).text()));
                $(td[pos + 3]).text(currencyFormatted($(td[pos + 3]).text()));
            }
        }

        $("#<%= TActaInicio.ClientID %>,#<%= TFinalizacion.ClientID %>").change(calcularDuracion).datepicker({
            onClose: function(dateText, inst) {
                calcularDuracion();
            }
        });
        $("#<%= TActaInicio.ClientID %>,#<%= TFinalizacion.ClientID %>").change();
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc1:proyecto ID="UCProyecto" runat="server" />
<asp:Panel runat="server" ID="PDatos">
    <asp:HiddenField runat="server" ID="HContrato" />
    <table class="tabla">
            <tr>
                <td>Fecha Diligenciamiento</td>
                <td><asp:TextBox runat="server" ID="TFechaDiligenciamiento" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TFechaDiligenciamiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td>Entidad ejecutora</td>
                <td><asp:TextBox runat="server" ID="TEntidadEjecutora"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Quien diliegencia el formulario</td>
                <td><asp:TextBox runat="server" ID="TResponsable"></asp:TextBox></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Datos generales del contrato</td>
            </tr>
            <tr>
                <td>Número de contrato</td>
                <td><asp:TextBox runat="server" ID="TNumero"></asp:TextBox></td>
                <td>Vigencia</td>
                <td><asp:TextBox runat="server" ID="TVigencia"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Número encargo fiduciario</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TNumeroEncargo"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Lugar ejecución departamento</td>
                <td><asp:DropDownList ID="DDepartamento" runat="server" 
                            DataSourceID="SDepartamento" DataTextField="nombre" DataValueField="id" 
                            AutoPostBack="true" onselectedindexchanged="DDepartamento_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDepartamento" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=101 AND szReservado IS NULL ORDER BY nombre" >
                    </asp:SqlDataSource>
                        <asp:Label ID="LGrupo" runat="server" Text=""></asp:Label></td>
                <td>Municipio</td>
                <td><asp:DropDownList ID="DMunicipio" runat="server" DataSourceID="SMunicipio" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SMunicipio" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared 
                            WHERE nReservado=102 AND szReservado IS NULL AND descripcion=@departamento ORDER BY nombre" >
                            <SelectParameters>
                            <asp:ControlParameter ControlID="DDepartamento" Name="departamento" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Objeto del contrato</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TObjeto" TextMode="MultiLine" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Forma de pago</td>
                <td><asp:TextBox runat="server" ID="TFormaPago"></asp:TextBox></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan=4 class="Titulo">Valor del contrato</td>
            </tr>
            <tr>
                <td>Recursos propios</td>
                <td><asp:TextBox runat="server" ID="TRPropios" CssClass="dinero"></asp:TextBox></td>
                <td>Recursos de Colombia humanitaria</td>
                <td><asp:TextBox runat="server" ID="TRColombiaH" CssClass="dinero"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Recursos otras fuentes</td>
                <td><asp:TextBox runat="server" ID="TROtras" CssClass="dinero"></asp:TextBox></td>
                <td>Valor total</td>
                <td align="right"><asp:Label runat="server" ID="LTotalR"></asp:Label></td>
            </tr>
            <tr>
                <td>Fecha última adición</td>
                <td><asp:TextBox runat="server" ID="TFAdicion" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TFAdicion" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator10" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td>Valor adición</td>
                <td><asp:TextBox runat="server" ID="TAdicion" CssClass="dinero"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Valor total mas adiciones</td>
                <td align="right" colspan="3"><asp:Label runat="server" ID="LTotalC"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Duración</td>
            </tr>
            <tr>
                <td>Acta inicio</td>
                <td><asp:TextBox runat="server" ID="TActaInicio" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TActaInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td>Finalización</td>
                <td><asp:TextBox runat="server" ID="TFinalizacion" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TFinalizacion" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            </tr>
            <tr>
                <td>Finalización Última prorroga</td>
                <td><asp:TextBox runat="server" ID="TUProrroga" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TUProrroga" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator4" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td>Duración (Meses)</td>
                <td><asp:Label runat="server" ID="LDuracion"></asp:Label></td>
            </tr>
            <tr>
                <td class="Titulo" colspan=4>Pólizas</td>
            </tr>
            <tr>
                <td colspan="4"><asp:GridView ID="GPolizas" runat="server" AutoGenerateColumns="False" DataSourceID="SPolizas" EmptyDataText="No se encontraron polizas" DataKeyNames="id">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:TemplateField HeaderText="Tipo">
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="TTipo" Text='<%# Eval("tipo") %>' Width="250px"></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Número">
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="TNumero" Text='<%# Eval("numero") %>'></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Aseguradora">
                        <ItemTemplate>
                            <asp:DropDownList ID="DAseguradora" runat="server" SelectedValue='<%# Eval("aseguradora") %>'
                                DataSourceID="SAseguradora" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SAseguradora" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=126 AND szReservado IS NULL ORDER BY nombre" >
                        </asp:SqlDataSource>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Vencimiento">
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="TVencimiento" CssClass="fecha" Text='<%# Eval("vencimiento") %>'></asp:TextBox>
                            <asp:RangeValidator ControlToValidate="TVencimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
                <sdg:CustomDataSource ID="SPolizas" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    SelectCommand="(SELECT contrato_proyecto_polizas.id, shared.nombre AS tipo,contrato_proyecto_polizas.numero,contrato_proyecto_polizas.aseguradora,contrato_proyecto_polizas.vencimiento FROM shared 
                                    LEFT JOIN contrato_proyecto_polizas ON (contrato_proyecto_polizas.proyecto=@proyecto AND contrato_proyecto_polizas.tipo=shared.nombre) 
                                    WHERE shared.nReservado=125 AND shared.szReservado IS NULL ORDER BY tipo) UNION (
                                    SELECT id,tipo,numero,aseguradora,vencimiento
                                    FROM contrato_proyecto_polizas
                                    WHERE proyecto=@proyecto
                                    )"
                    InsertCommand="INSERT INTO contrato_proyecto_polizas (tipo,numero,aseguradora,vencimiento) VALUES (@tipo,@numero,@aseguradora,@vencimiento)"
                    DeleteCommand="DELETE FROM contrato_proyecto_polizas WHERE id=@id">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HContrato" Name="proyecto" PropertyName="Value" DefaultValue="0" />
                      </SelectParameters>
                </sdg:CustomDataSource></td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                    <asp:Button runat="server" ID="BMasPolizas" CausesValidation="false" Text="+" onclick="BMasPolizas_Click" />
                </td>
            </tr>
            <tr>
                <td colspan="4" class="Titulo">Datos financieros</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GFinanciero" runat="server" AutoGenerateColumns="False" DataSourceID="SFinanciero" EmptyDataText="No se encontraron giros" DataKeyNames="id">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
		            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField HeaderText="Programada" DataField="programado" SortExpression="programado" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                    <asp:BoundField HeaderText="Porcentaje" DataField="porcentajep" SortExpression="porcentajep" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField HeaderText="Valor" DataField="valorp" SortExpression="valorp" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField HeaderText="Girada" DataField="giro" SortExpression="giro" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                    <asp:BoundField HeaderText="Porcentaje" DataField="porcentajeg" SortExpression="porcentajeg" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField HeaderText="Valor" DataField="valorg" SortExpression="valorg" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField HeaderText="Observaciones" DataField="observaciones" SortExpression="observaciones" />
                </Columns>
            </asp:GridView>
                <sdg:CustomDataSource ID="SFinanciero" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    SelectCommand="SELECT id,programado,CAST(porcentajep AS CHAR) AS porcentajep,CAST(valorp AS CHAR) AS valorp,giro,CAST(porcentajeg AS CHAR) AS porcentajeg,CAST(valorg AS CHAR) AS valorg,observaciones FROM contrato_proyecto_giros WHERE proyecto=@proyecto"
                    DeleteCommand="DELETE FROM contrato_proyecto_giros WHERE id=@id">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HContrato" Name="proyecto" PropertyName="Value" DefaultValue="0" />
                      </SelectParameters>
                </sdg:CustomDataSource>
                
                <div id="dNivelEducativo" title="Datos financieros">
                    <asp:DetailsView ID="DFinanciero" runat="server" Width="100%" 
                        DataSourceID="SDFinanciero" DataKeyNames="id" 
                        AutoGenerateRows="False" DefaultMode="Edit" 
                        oniteminserted="DFinanciero_ItemInserted" 
                        onitemupdated="DFinanciero_ItemUpdated" 
                        onitemcommand="DFinanciero_ItemCommand">
                        <Fields>
                            <asp:TemplateField HeaderText="Programado">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" ID="TProgramado" CssClass="fecha" Text='<%# Bind("programado") %>'></asp:TextBox>
                                    <asp:RangeValidator ControlToValidate="TProgramado" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox runat="server" ID="TProgramado" CssClass="fecha" Text='<%# Bind("programado") %>'></asp:TextBox>
                                    <asp:RangeValidator ControlToValidate="TProgramado" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Porcentaje programado">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" ID="TPProgramado" CssClass="float" Text='<%# Bind("porcentajep") %>'></asp:TextBox>%
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox runat="server" ID="TPProgramado" CssClass="float" Text='<%# Bind("porcentajep") %>'></asp:TextBox>%
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Valor programado">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" ID="TVProgramado" CssClass="dinero" Text='<%# Bind("valorp") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox runat="server" ID="TVProgramado" CssClass="dinero" Text='<%# Bind("valorp") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Girado">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" ID="TGiro" CssClass="fecha" Text='<%# Bind("giro") %>'></asp:TextBox>
                                    <asp:RangeValidator ControlToValidate="TGiro" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox runat="server" ID="TGiro" CssClass="fecha" Text='<%# Bind("giro") %>'></asp:TextBox>
                                    <asp:RangeValidator ControlToValidate="TGiro" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Porcentaje girado">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" ID="TPGirado" CssClass="float" Text='<%# Bind("porcentajeg") %>'></asp:TextBox>%
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox runat="server" ID="TPGirado" CssClass="float" Text='<%# Bind("porcentajeg") %>'></asp:TextBox>%
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Valor girado">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" ID="TVGirado" CssClass="dinero" Text='<%# Bind("valorg") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox runat="server" ID="TVGirado" CssClass="dinero" Text='<%# Bind("valorg") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Observaciones">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="98%" Text='<%# Bind("observaciones") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="98%" Text='<%# Bind("observaciones") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                            <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                        </Fields>
                    </asp:DetailsView>
                    </div>
                    <sdg:CustomDataSource ID="SDFinanciero" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    SelectCommand="SELECT programado,porcentajep,valorp,giro,porcentajeg,valorg,observaciones FROM contrato_proyecto_giros WHERE id=@id"
                                    InsertCommand="INSERT INTO contrato_proyecto_giros(proyecto,STR_TO_DATE(programado, '%d/%m/%Y'),porcentajep,REPLACE(valorp,',',''),STR_TO_DATE(giro, '%d/%m/%Y'),porcentajeg,REPLACE(valorg,',',''),observaciones) VALUES (@proyecto,@programado,@porcentajep,@valorp,@giro,@porcentajeg,@valorg,@observaciones)"
                                    UpdateCommand="UPDATE contrato_proyecto_giros SET programado=STR_TO_DATE(@programado, '%d/%m/%Y'),porcentajep=@porcentajep,valorp=REPLACE(@valorp,',',''),giro=STR_TO_DATE(@giro, '%d/%m/%Y'),porcentajeg=@porcentajeg,valorg=REPLACE(@valorg,',',''),observaciones=@observaciones WHERE id=@id" 
                                    ParentDataSource="SFinanciero"
                                    >
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="GFinanciero" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                                    </SelectParameters>
                                    <UpdateParameters>
                                        <asp:ControlParameter ControlID="GFinanciero" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                                    </UpdateParameters>
                </sdg:CustomDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                    <asp:Button runat="server" ID="BMasFinanciero" CausesValidation="true" Text="+" onclick="BMasFinanciero_Click" />
                </td>
            </tr>
            <tr>
            <td align="right" colspan=4>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" />
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="false" Text="Cancelar" onclick="BCancelar_Click" />
            </td>
        </tr>
   </table>
</asp:Panel>
</asp:Content>

