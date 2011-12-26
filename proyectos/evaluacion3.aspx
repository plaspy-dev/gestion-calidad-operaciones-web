<%@ Page Title="Afectación de servicios públicos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evaluacion3.aspx.cs" Inherits="proyectos_evaluacion3" %>
<%@ Register src="proyector.ascx" tagname="proyector" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        addDialog("#dEquipoParent", "#dEquipo");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc1:proyector ID="UCProyecto" runat="server" />
    <asp:Panel runat="server" ID="PDatos" Visible="false">
        <asp:HiddenField runat="server" ID="HEvaluacion" />
        <table class="tabla">
            <tr>
                <td colspan="6" class="Titulo">Instalaciones hidraulicas y sanitarias</td>
            </tr>
            <tr>
                <td colspan="2" class="SubTitulo">
                    Suministro de agua</td>
                <td colspan="2" class="SubTitulo">
                    Desagues</td>
                <td colspan="2" class="SubTitulo">
                    Almacenamiento</td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:CheckBox ID="CAguaConexion" runat="server" Text="Conexión a red pública" />
                    </td>
                <td colspan="2">
                    <asp:CheckBox ID="CDesagueConexion" runat="server" Text="Conexión a red pública" />
                </td>
                <td>
                    Capacidad</td>
                <td>
                    <asp:TextBox ID="TAlmacenamientoCapacidad" runat="server" CssClass="entero"></asp:TextBox>
                    m<sup>3</sup></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:CheckBox ID="CAguaIPropia" runat="server" Text="Instalación propia" />
                </td>
                <td colspan="2">
                    <asp:CheckBox ID="CDesagueIPropia" runat="server" 
                        Text="Instalación propia" />
                </td>
                <td colspan="2">
                    <asp:CheckBox ID="CAlmacenamientoElevado" runat="server" Text="Elevado" />
                </td>
            </tr>
            <tr>
                <td>
                    Otro
                </td>
                <td>
                    <asp:TextBox ID="TAguaOtro" runat="server"></asp:TextBox>
                </td>
                <td>
                    Otro
                </td>
                <td>
                    <asp:TextBox ID="TDesagueOtro" runat="server"></asp:TextBox>
                </td>
                <td colspan="2">
                    <asp:CheckBox ID="CAlmacenamientoSubterraneo" runat="server" Text="Subterraneo" />
                </td>
            </tr>
            <tr>
                <td>
                    Afectación
                </td>
                <td>
                    <asp:TextBox ID="TAguaAfectacion" runat="server"></asp:TextBox>
                </td>
                <td>
                    Afectación
                </td>
                <td>
                    <asp:TextBox ID="TDesagueAfectacion" runat="server"></asp:TextBox>
                </td>
                <td>
                    Afectación
                </td>
                <td>
                    <asp:TextBox ID="TAlmacenamientoAfectacion" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Observaciones</td>
                <td colspan="5">
                    <asp:TextBox ID="TAguaObservaciones" runat="server" TextMode="MultiLine" 
                        Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="Titulo" colspan="6">
                    Instalaciones eléctricas</td>
            </tr>
            <tr>
                <td class="SubTitulo" colspan="2">
                    Suministro de energía</td>
                <td class="SubTitulo" colspan="2">
                    Estado de la red eléctrica</td>
                <td class="SubTitulo" colspan="2">
                    Planta de emergencia</td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:CheckBox ID="CEnergiaConexion" runat="server" Text="Conexión a red pública" />
                </td>
                <td>
                    Estado</td>
                <td>
                    <asp:DropDownList ID="DRedEstado" runat="server" DataSourceID="SEstado" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(No definido)" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SEstado" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=119 AND szReservado IS NULL ORDER BY nombre" >
                    </asp:SqlDataSource></td>
                <td>
                    Capacidad</td>
                <td>
                    <asp:TextBox ID="TPlantaCapacidad" runat="server" CssClass="entero"></asp:TextBox>
                    Kva</td>
            </tr>
            <tr>
                <td>
                    Otro
                </td>
                <td>
                    <asp:TextBox ID="TEnergiaOtro" runat="server"></asp:TextBox>
                </td>
                <td>
                    Afectación</td>
                <td>
                    <asp:TextBox ID="TRedAfectacion" runat="server"></asp:TextBox>
                </td>
                <td>
                    Estado</td>
                <td>
                    <asp:DropDownList ID="DPlantaEstado" runat="server" DataSourceID="SEstado" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(No definido)" Value=""></asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td>
                    Observaciones</td>
                <td colspan="5">
                    <asp:TextBox ID="TEnergiaObservaciones" runat="server" TextMode="MultiLine" 
                        Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="Titulo" colspan="6">
                    Afectación de equipos fijos</td>
            </tr>
            <tr>
                <td colspan="6">
                <asp:GridView ID="GEquipos" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron equipos"
                        DataSourceID="SEquipos" DataKeyNames="id">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField HeaderText="Nombre" DataField="nombre" />
                            <asp:BoundField HeaderText="Capacidad" DataField="capacidad" />
                            <asp:CheckBoxField HeaderText="Funciona" DataField="funciona" />
                            <asp:BoundField HeaderText="Afectación" DataField="afectacion" />
                        </Columns>
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SEquipos" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        SelectCommand="SELECT id,nombre,capacidad,funciona,afectacion FROM evaluacion_equipos WHERE proyecto=@proyecto" 
                        DeleteCommand="DETETE FROM evaluacion_equipos WHERE id=@id"
                        >
                        <SelectParameters>
                            <asp:ControlParameter ControlID="UCProyecto" PropertyName="IdProyecto" Name="proyecto" />
                        </SelectParameters>
                    </sdg:CustomDataSource>
                    
                    <div id="dEquipoParent">
                    <div id="dEquipo" title="Equipo" style="display:none">
                    <asp:DetailsView ID="DEquipo" runat="server" Width="100%" 
                        DataSourceID="SEquipo" DataKeyNames="id" 
                        AutoGenerateRows="False" DefaultMode="Edit" 
                            onitemcommand="DEquipo_ItemCommand" oniteminserted="DEquipo_ItemInserted" 
                            onitemupdated="DEquipo_ItemUpdated">
                        <Fields>
                            <asp:TemplateField HeaderText="Nombre">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TNombre" runat="server" Text='<%# Bind("nombre") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Por favor ingrese un nombre." ControlToValidate="TNombre" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TNombre" runat="server" Text='<%# Bind("nombre") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Por favor ingrese un nombre." ControlToValidate="TNombre" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Capacidad">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TCapacidad" runat="server" Text='<%# Bind("capacidad") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TCapacidad" runat="server" Text='<%# Bind("capacidad") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="">
                                <EditItemTemplate>
                                    <asp:CheckBox runat="server" ID="CFunciona" Text="Funciona" Checked='<%# Bind("funciona") %>' />
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:CheckBox runat="server" ID="CFunciona" Text="Funciona" Checked='<%# Bind("funciona") %>' />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Afectación" DataField="afectacion" />
                            <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                            <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                        </Fields>
                    </asp:DetailsView>
                    </div>
                    </div>
                    <sdg:CustomDataSource ID="SEquipo" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    SelectCommand="SELECT id,nombre,capacidad,funciona,afectacion FROM evaluacion_equipos WHERE id=@id"
                                    InsertCommand="INSERT INTO evaluacion_equipos(nombre,capacidad,funciona,afectacion,proyecto) VALUES (@nombre,@capacidad,@funciona,@afectacion,@proyecto)"
                                    UpdateCommand="UPDATE evaluacion_equipos SET nombre=@nombre,capacidad=@capacidad,funciona=@funciona,afectacion=@afectacion WHERE id=@id" 
                                    ParentDataSource="SEquipos"
                                    >
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="GEquipos" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                                    </SelectParameters>
                                    <UpdateParameters>
                                        <asp:ControlParameter ControlID="GEquipos" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                                    </UpdateParameters>
                    </sdg:CustomDataSource>
                    </td>
            </tr>
            <tr>
                <td colspan="6" align="right">
                    <asp:Button runat="server" ID="BMas" CausesValidation="false" Text="+" 
                        onclick="BMas_Click" />
                </td>
            </tr>
            <tr>
                <td>
                    Observaciones</td>
                <td colspan="5">
                    <asp:TextBox ID="TEquiposObservaciones" runat="server" TextMode="MultiLine" 
                        Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="6" align="right">
                    <asp:Button runat="server" Text="Aceptar" ID="BAceptar" 
                        onclick="BAceptar_Click" />
                    <asp:Button runat="server" Text="Cancelar" ID="BCancelar" 
                        CausesValidation="false" onclick="BCancelar_Click" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>

