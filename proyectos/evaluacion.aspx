<%@ Page Title="Evaluación inmuebles" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evaluacion.aspx.cs" Inherits="proyectos_evaluacion" %>
<%@ Register src="proyector.ascx" tagname="proyector" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc1:proyector ID="UCProyecto" runat="server" />
    <asp:Panel runat="server" ID="PDatos" Visible="false">
    <asp:HiddenField runat="server" ID="HEvaluacion" />
        <table border="1">
            <tr>
                <td colspan="4" class="celdaTitulo">Concepto preliminar</td>
            </tr>
            <tr>
                <td>Reposición</td>
                <td><asp:DropDownList ID="DReposicion" runat="server" DataSourceID="SReposicion" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SReposicion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=107 AND szReservado IS NULL ORDER BY nombre" >
            </asp:SqlDataSource></td>
                <td>Adecuación</td>
                <td><asp:DropDownList ID="DAdecuacion" runat="server" DataSourceID="SAdecuacion" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SAdecuacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=108 AND szReservado IS NULL ORDER BY nombre" >
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GReubicacion" runat="server" AutoGenerateColumns="False" Width="100%"
                        DataSourceID="SReubicacion" DataKeyNames="id,idreubicacion">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Concepto">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CEstado" runat="server" Text='<%# Eval("nombre") %>' Checked='<%# Eval("estado").ToString()=="1" %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SReubicacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT shared.id AS id, shared.nombre AS nombre,reubicacion_evaluacion.id AS idreubicacion,reubicacion_evaluacion.estado AS estado FROM shared LEFT JOIN reubicacion_evaluacion ON (reubicacion_evaluacion.proyecto=@evaluacion AND reubicacion_evaluacion.reubicacion=shared.id) WHERE shared.nReservado=109 AND shared.szReservado IS NULL" >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HEvaluacion" Name="evaluacion" PropertyName="Value" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>Observaciones</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TObservaciones" Width="99%" TextMode="MultiLine"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Condiciones actuales</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Afectaciones</td>
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
                <td colspan="4" class="celdaTitulo">Condiciones climaticas</td>
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
                <td><asp:TextBox runat="server" CssClass="entero" ID="TTemperatura"></asp:TextBox></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Acceso</td>
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
                <td colspan="4" class="celdaTitulo">Datos juridicos</td>
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
                <td colspan="4" class="celdaTitulo">Áreas</td>
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
                <td colspan="4" class="celdaTitulo">Terreno</td>
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
                <td colspan="4" class="celdaTitulo">Edificios</td>
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
                <td colspan="4" class="celdaTitulo">Exteriores</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GExteriores" runat="server" AutoGenerateColumns="False" 
                        DataSourceID="Sexteriores" DataKeyNames="id,idexteriores">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
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

