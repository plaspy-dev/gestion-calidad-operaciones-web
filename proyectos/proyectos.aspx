<%@ Page Title="Proyectos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="proyectos.aspx.cs" Inherits="proyectos_proyectos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.cobs 
{
    min-width: 400px;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Grupo</td>
            <td>
                Departamento</td>
            <td>
                Municipio</td>
            <td>
                Intervención</td>
            <td>
                Viable</td>
            <td>
                Nombre</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:DropDownList ID="DGrupo" runat="server" AppendDataBoundItems="true" 
                    AutoPostBack="true" DataSourceID="SGrupo" DataTextField="nombre" 
                    DataValueField="nombre" onselectedindexchanged="DGrupo_SelectedIndexChanged">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SGrupo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT nombre FROM shared WHERE nReservado=100 AND szReservado IS NULL">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DDepartamento" runat="server" AppendDataBoundItems="true" 
                    AutoPostBack="true" DataSourceID="SDepartamento" DataTextField="nombre" 
                    DataValueField="id" onselectedindexchanged="DDepartamento_SelectedIndexChanged">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SDepartamento" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=101 AND szReservado IS NULL AND (@grupo='0' OR descripcion=@grupo)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="DGrupo" Name="grupo" 
                            PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DMunicipio" runat="server" AutoPostBack="true" 
                    DataSourceID="SMunicipio" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SMunicipio" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="(SELECT 0 AS id,'(Todos)' AS nombre) UNION (SELECT id, nombre FROM shared 
                    WHERE nReservado=102 AND szReservado IS NULL AND descripcion=@departamento)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="DDepartamento" Name="departamento" 
                            PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DTIntervencion" runat="server" AppendDataBoundItems="true" 
                    AutoPostBack="true" DataSourceID="STIntervencion" DataTextField="nombre" 
                    DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STIntervencion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=108 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList runat="server" ID="DViable" AutoPostBack="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Viable" Value="1"></asp:ListItem>
                    <asp:ListItem Text="No viable" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron proyectos" 
        AllowPaging="True" PageSize="50" AllowSorting="True" ShowFooter="True">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="grupo" HeaderText="Grupo" SortExpression="grupo" />
            <asp:HyperLinkField DataTextField="nombre" HeaderText="Nombre" 
                DataNavigateUrlFields="id" SortExpression="nombre"
                DataNavigateUrlFormatString="~/proyectos/Default.aspx?idp={0}">
                <ItemStyle Wrap="false" />
            </asp:HyperLinkField>
            <asp:BoundField DataField="departamento" HeaderText="Departamento" SortExpression="departamento" />
            <asp:BoundField DataField="municipio" HeaderText="Municipio" SortExpression="municipio" />
            <asp:BoundField DataField="sede" HeaderText="Sede" SortExpression="sede" />
            <asp:BoundField DataField="tinstitucion" HeaderText="Tipo institución" SortExpression="tinstitucion">
                <ItemStyle Wrap="false" />
            </asp:BoundField>
            <asp:BoundField DataField="tlocalidad" HeaderText="Tipo localidad" SortExpression="tlocalidad" />
            <asp:BoundField DataField="tintervencion" HeaderText="Tipo intervención" SortExpression="tintervencion" />
            <asp:BoundField DataField="adecuacion" HeaderText="Tipo adecuación" SortExpression="adecuacion" />
            <asp:TemplateField HeaderText="Viable">
                <ItemTemplate>
                    <%# Eval("viable").ToString()=="1" ? "Sí" : "No" %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="area_afectada" HeaderText="Área afectada" SortExpression="area_afectada" >
                <ItemStyle HorizontalAlign="Right" Wrap="false" />
                <FooterStyle HorizontalAlign="Right" Wrap="false" />
            </asp:BoundField>
            <asp:BoundField DataField="presupuesto_inicial" HeaderText="Presupuesto inicial" SortExpression="presupuesto_inicial" DataFormatString="{0:c}">
                <ItemStyle HorizontalAlign="Right" Wrap="false" />
                <FooterStyle HorizontalAlign="Right" Wrap="false" />
            </asp:BoundField>
            <asp:BoundField DataField="presupuesto_dotacion" HeaderText="Presupuesto dotación" SortExpression="presupuesto_dotacion" DataFormatString="{0:c}" >
                <ItemStyle HorizontalAlign="Right" Wrap="false" />
                <FooterStyle HorizontalAlign="Right" Wrap="false" />
            </asp:BoundField>
            <asp:BoundField DataField="presupuestog" HeaderText="Presupuesto gerencia" SortExpression="presupuestog" DataFormatString="{0:c}">
                <ItemStyle HorizontalAlign="Right" Wrap="false" />
                <FooterStyle HorizontalAlign="Right" Wrap="false" />
            </asp:BoundField>
            <asp:BoundField DataField="pdotaciong" HeaderText="Presupuesto dotación gerencia" SortExpression="pdotaciong" DataFormatString="{0:c}" >
                <ItemStyle HorizontalAlign="Right" Wrap="false" />
                <FooterStyle HorizontalAlign="Right" Wrap="false" />
            </asp:BoundField>
            <asp:BoundField DataField="observaciones" HeaderText="Observaciones" SortExpression="observaciones" ItemStyle-CssClass="cobs" >
                <ItemStyle CssClass="cobs"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="observacionesg" HeaderText="Observaciones gerencia" SortExpression="observacionesg" ItemStyle-CssClass="cobs" >
                <ItemStyle CssClass="cobs"></ItemStyle>
            </asp:BoundField>
        </Columns>
    </asp:GridView>
    <div style="text-align: right"><asp:Label runat="server" ID="LTotal"></asp:Label></div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT proyecto.id,proyecto.sede,proyecto.nombre,departamento.nombre AS departamento
                    ,municipio.nombre AS municipio,tinstitucion.nombre AS tinstitucion,localidad.nombre AS tlocalidad,tintervencion.nombre AS tintervencion
                    ,proyecto.presupuesto_inicial,proyecto.area_afectada,proyecto.presupuesto_dotacion,proyecto.observaciones
                    ,departamento.descripcion AS grupo, evaluacion.observaciones AS observacionesg
                    ,evaluacion.presupuesto_inicial AS presupuestog,evaluacion.presupuesto_dotacion AS pdotaciong
                    ,adecuacion.nombre AS adecuacion,evaluacion.viable
                    FROM proyecto
                    LEFT JOIN shared AS departamento ON (departamento.id=proyecto.departamento)
                    LEFT JOIN shared AS municipio ON (municipio.id=proyecto.municipio)
                    LEFT JOIN shared AS localidad ON (localidad.id=proyecto.localidad)
                    LEFT JOIN shared AS tintervencion ON (tintervencion.id=proyecto.tintervencion)
                    LEFT JOIN shared AS tinstitucion ON (tinstitucion.id=proyecto.tinstitucion)
                    LEFT JOIN evaluacion ON (evaluacion.proyecto=proyecto.id)
                    LEFT JOIN shared AS adecuacion ON (adecuacion.id=evaluacion.adecuacion)
                    WHERE 
                    (@grupo='0' OR departamento.descripcion=@grupo)
                    AND (@departamento=0 OR proyecto.departamento=@departamento)
                    AND (@municipio=0 OR proyecto.municipio=@municipio)
                    AND (@intervencion=0 OR evaluacion.adecuacion=@intervencion)
                    AND (@viable=0 OR (@viable=1 AND @viable=evaluacion.viable) OR (@viable=2 AND evaluacion.viable IS NULL))
                    AND (@nombres='' OR proyecto.nombre LIKE CONCAT('%', @nombres, '%'))
                    ;">
        <SelectParameters>
            <asp:ControlParameter ControlID="TNombres" Name="nombres" PropertyName="Text" ConvertEmptyStringToNull="false" />
            <asp:ControlParameter ControlID="DGrupo" Name="grupo" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDepartamento" Name="departamento" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DMunicipio" Name="municipio" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DTIntervencion" Name="intervencion" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DViable" Name="viable" PropertyName="SelectedValue" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

