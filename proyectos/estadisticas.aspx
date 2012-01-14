<%@ Page Title="Estadísticas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="estadisticas.aspx.cs" Inherits="proyectos_estadisticas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {

        function addTableRow(jQtable) {
            jQtable.each(function() {
                tds = $('tr:last', this).clone();
                if ($('tbody', this).length > 0) {
                    $('tbody', this).append(tds);
                } else {
                    $(this).append(tds);
                }
                $('tr:last td', this).html("");
            });
            return jQtable;
        }

        function addPorcentajes(tabla, inicio, mensaje) {

            var encabezado = "<tr class='Titulo'><td colspan=" + (inicio-5).toString() + " align=center><b>DATOS GENERALES</b></td>"
            encabezado += "<td colspan=5 align=center><b>EJECUCIÓN PRESUPUESTAL</b></td>";
            encabezado += "<td align=center colspan=1><b></b></td>";
            encabezado += "<td align=center colspan=3><b>TIPO DE EDIFICACIÓN</b></td>";
            encabezado += "<td align=center colspan=3><b>OBJETOS DE INTERVENCIÓN</b></td>";
            encabezado += "<td align=center colspan=4><b>OBJETOS DE NO INTERVENCIÓN</b></td>";
            encabezado += "<td align=center colspan=2><b>PENDIENTES</b></td>";
            encabezado += "</tr>";
            $(tabla + ' > tbody > tr:first').before(encabezado);

            var totales = $(tabla).find("tr:last td");
            var tds = addTableRow($(tabla)).find("tr:last td");
            var total = parseInt($(totales[inicio]).text());
            $(tds[mensaje]).html("Peso porcentual");
            for (var i = inicio; i < tds.length; i++) {
                if (total > 0)
                    $(tds[i]).html(numberFormatted(parseInt($(totales[i]).text()) * 100 / total) + "%");
                else $(tds[i]).html("0.00%");
            }
        }
        addPorcentajes('#<%= GResultados.ClientID %>', 8, 1);
        if ($("#<%= PDetalles.ClientID %>").length > 0)
            addPorcentajes('#<%= GDetalles.ClientID %>', 7, 1);
        if ($("#<%= PDDepartamento.ClientID %>").length > 0)
            addPorcentajes('#<%= GDDepartamento.ClientID %>', 6, 0);

        if ($("#<%= PDDepartamento.ClientID %>").length > 0)
            $("html:not(:animated),body:not(:animated)").animate({ scrollTop: $("#<%= PDDepartamento.ClientID %>").offset().top }, 1100);
        else if ($("#<%= PDetalles.ClientID %>").length > 0)
            $("html:not(:animated),body:not(:animated)").animate({ scrollTop: $("#<%= PDetalles.ClientID %>").offset().top }, 1100);
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron proyectos" 
        AllowSorting="True" ShowFooter="True" DataKeyNames="grupo" 
        onselectedindexchanged="GResultados_SelectedIndexChanged">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:TemplateField HeaderText="GRUPO" SortExpression="grupo">
                <ItemTemplate>
                    <asp:LinkButton ID="LS" runat="server" CausesValidation="False" CommandName="Select" Text='<%# Eval("grupo") %>'></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="departamento" HeaderText="DEPARTAMENTO" 
                SortExpression="departamento" ItemStyle-Wrap="false">
<ItemStyle Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="municipios" HeaderText="MUNICIPIOS" 
                SortExpression="municipios" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="total" HeaderText="TOTAL " SortExpression="total" 
                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="amenor" HeaderText="ADECUACIONES MENORES" 
                SortExpression="amenor" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="amayor" HeaderText="ADECUACIONES MAYORES" 
                SortExpression="amayor" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="dotacion" HeaderText="DOTACION" 
                SortExpression="dotacion" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="inversion" HeaderText="% INVERSION" 
                SortExpression="inversion" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:p}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="proyectosrecibidos" HeaderText="PROYECTOS RECIBIDOS" 
                SortExpression="proyectosrecibidos" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="puesto" HeaderText="PUESTO DE SALUD" 
                SortExpression="puesto" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="centro" HeaderText="CENTRO DE SALUD" 
                SortExpression="centro" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="hospital" HeaderText="HOSPITAL LOCAL" 
                SortExpression="hospital" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oimenor" HeaderText="ADECUACIÓN MENOR" 
                SortExpression="oimenor" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oimayor" HeaderText="ADECUACIÓN MAYOR" 
                SortExpression="oimayor" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oidotacion" HeaderText="DOTACION" 
                SortExpression="oidotacion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreposicion" HeaderText="REPOSICION " 
                SortExpression="noreposicion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreubicacion" HeaderText="REUBICACION" 
                SortExpression="noreubicacion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreparada" HeaderText="REPARADA" 
                SortExpression="noreparada" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noviable" HeaderText="NO VIABLE" 
                SortExpression="noviable" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oipdocumentacion" 
                HeaderText="PENDIENTE X DOCUMENTACION" SortExpression="oipdocumentacion" 
                ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oipvisita" HeaderText="PENDIENTE X VISITA" 
                SortExpression="oipvisita" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>
<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                        departamento.descripcion AS grupo
                        ,departamento.nombre AS departamento
                        ,COUNT(DISTINCT proyecto.municipio) AS municipios
                        ,SUM(evaluacion.presupuesto_inicial) AS total
                        ,SUM(IF(tipoadecuacion.nombre LIKE '%menor%', evaluacion.presupuesto_inicial, 0)) AS amenor
                        ,SUM(IF(tipoadecuacion.nombre LIKE '%mayor%', evaluacion.presupuesto_inicial, 0)) AS amayor
                        ,SUM(IF(evaluacion.dotacion, evaluacion.presupuesto_inicial,0)) AS dotacion
                        ,SUM(evaluacion.presupuesto_inicial)/(SELECT SUM(presupuesto_inicial) FROM evaluacion) AS inversion
                        ,COUNT(proyecto.id) AS proyectosrecibidos
                        ,COUNT(IF(tinstitucion.nombre LIKE '%puesto%', 1, NULL)) AS puesto
                        ,COUNT(IF(tinstitucion.nombre LIKE '%centro%', 1, NULL)) AS centro
                        ,COUNT(IF(tinstitucion.nombre LIKE '%hospital%', 1, NULL)) AS hospital
                        ,COUNT(IF(evaluacion.estado=1 AND tipoadecuacion.nombre LIKE '%menor%',1, NULL)) AS oimenor
                        ,COUNT(IF(evaluacion.estado=1 AND tipoadecuacion.nombre LIKE '%mayor%',1, NULL)) AS oimayor
                        ,COUNT(IF(evaluacion.estado=1 AND evaluacion.dotacion,1, NULL)) AS oidotacion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%repos%',1, NULL)) AS noreposicion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%reub%',1, NULL)) AS noreubicacion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%repara%',1, NULL)) AS noreparada
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%viable%',1, NULL)) AS noviable
                        ,COUNT(IF(evaluacion.estado=1 AND onointervencion.nombre LIKE '%documen%',1, NULL)) AS oipdocumentacion
                        ,COUNT(IF(evaluacion.estado=1 AND onointervencion.nombre LIKE '%visita%',1, NULL)) AS oipvisita
                        FROM proyecto
                        LEFT JOIN evaluacion ON (evaluacion.proyecto=proyecto.id) 
                        LEFT JOIN shared AS departamento ON (departamento.id=proyecto.departamento)
                        LEFT JOIN shared AS tipoadecuacion ON (tipoadecuacion.id=evaluacion.adecuacion)
                        LEFT JOIN shared AS tinstitucion ON (tinstitucion.id=proyecto.tinstitucion)
                        LEFT JOIN shared AS onointervencion ON (onointervencion.id=evaluacion.tipo_nointervencion)
                        GROUP BY departamento
                        ORDER BY grupo,departamento
                        ;">
    </asp:SqlDataSource>
    <br />
    
    <asp:Panel runat="server" ID="PDetalles" Visible="false">
    <table>
    <tr>
        <td class="Titulo"><asp:Label runat="server" ID="LGrupo"></asp:Label></td>
    </tr>
    <tr>
        <td>
    <asp:GridView ID="GDetalles" runat="server" DataSourceID="SDetalles" 
        AutoGenerateColumns="False" EmptyDataText="Por favor seleccione un grupo" 
        AllowSorting="True" ShowFooter="True" DataKeyNames="departamento"
        onselectedindexchanged="GDetalles_SelectedIndexChanged">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:TemplateField HeaderText="DEPARTAMENTO" SortExpression="departamento" ItemStyle-Wrap="false">
                <ItemTemplate>
                    <asp:LinkButton ID="LS" runat="server" CausesValidation="False" CommandName="Select" Text='<%# Eval("departamento") %>'></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="municipio" HeaderText="MUNICIPIO" SortExpression="municipio" ItemStyle-Wrap="false">
                <ItemStyle Wrap="False"></ItemStyle>
            </asp:BoundField>

            <asp:BoundField DataField="total" HeaderText="TOTAL " SortExpression="total" 
                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" FooterStyle-Wrap="false"
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="amenor" HeaderText="ADECUACIONES MENORES" 
                SortExpression="amenor" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="amayor" HeaderText="ADECUACIONES MAYORES" 
                SortExpression="amayor" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="dotacion" HeaderText="DOTACION" 
                SortExpression="dotacion" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="inversion" HeaderText="% INVERSION" 
                SortExpression="inversion" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:p}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="proyectosrecibidos" HeaderText="PROYECTOS RECIBIDOS" 
                SortExpression="proyectosrecibidos" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="puesto" HeaderText="PUESTO DE SALUD" 
                SortExpression="puesto" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="centro" HeaderText="CENTRO DE SALUD" 
                SortExpression="centro" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="hospital" HeaderText="HOSPITAL LOCAL" 
                SortExpression="hospital" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oimenor" HeaderText="ADECUACIÓN MENOR" 
                SortExpression="oimenor" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oimayor" HeaderText="ADECUACIÓN MAYOR" 
                SortExpression="oimayor" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oidotacion" HeaderText="DOTACION" 
                SortExpression="oidotacion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreposicion" HeaderText="REPOSICION " 
                SortExpression="noreposicion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreubicacion" HeaderText="REUBICACION" 
                SortExpression="noreubicacion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreparada" HeaderText="REPARADA" 
                SortExpression="noreparada" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noviable" HeaderText="NO VIABLE" 
                SortExpression="noviable" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oipdocumentacion" 
                HeaderText="PENDIENTE X DOCUMENTACION" SortExpression="oipdocumentacion" 
                ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oipvisita" HeaderText="PENDIENTE X VISITA" 
                SortExpression="oipvisita" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>
<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SDetalles" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                        departamento.nombre AS departamento
                        ,municipio.nombre AS municipio
                        ,SUM(evaluacion.presupuesto_inicial) AS total
                        ,SUM(IF(tipoadecuacion.nombre LIKE '%menor%', evaluacion.presupuesto_inicial, 0)) AS amenor
                        ,SUM(IF(tipoadecuacion.nombre LIKE '%mayor%', evaluacion.presupuesto_inicial, 0)) AS amayor
                        ,SUM(IF(evaluacion.dotacion, evaluacion.presupuesto_inicial,0)) AS dotacion
                        ,SUM(evaluacion.presupuesto_inicial)/(SELECT SUM(evaluacion.presupuesto_inicial) FROM evaluacion LEFT JOIN proyecto ON proyecto.id=evaluacion.proyecto LEFT JOIN shared ON proyecto.departamento=shared.id WHERE shared.descripcion=@grupo) AS inversion
                        ,COUNT(proyecto.id) AS proyectosrecibidos
                        ,COUNT(IF(tinstitucion.nombre LIKE '%puesto%', 1, NULL)) AS puesto
                        ,COUNT(IF(tinstitucion.nombre LIKE '%centro%', 1, NULL)) AS centro
                        ,COUNT(IF(tinstitucion.nombre LIKE '%hospital%', 1, NULL)) AS hospital
                        ,COUNT(IF(evaluacion.estado=1 AND tipoadecuacion.nombre LIKE '%menor%',1, NULL)) AS oimenor
                        ,COUNT(IF(evaluacion.estado=1 AND tipoadecuacion.nombre LIKE '%mayor%',1, NULL)) AS oimayor
                        ,COUNT(IF(evaluacion.estado=1 AND evaluacion.dotacion,1, NULL)) AS oidotacion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%repos%',1, NULL)) AS noreposicion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%reub%',1, NULL)) AS noreubicacion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%repara%',1, NULL)) AS noreparada
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%viable%',1, NULL)) AS noviable
                        ,COUNT(IF(evaluacion.estado=1 AND onointervencion.nombre LIKE '%documen%',1, NULL)) AS oipdocumentacion
                        ,COUNT(IF(evaluacion.estado=1 AND onointervencion.nombre LIKE '%visita%',1, NULL)) AS oipvisita
                        FROM proyecto
                        LEFT JOIN evaluacion ON (evaluacion.proyecto=proyecto.id) 
                        LEFT JOIN shared AS departamento ON (departamento.id=proyecto.departamento)
                        LEFT JOIN shared AS municipio ON (municipio.id=proyecto.municipio)
                        LEFT JOIN shared AS tipoadecuacion ON (tipoadecuacion.id=evaluacion.adecuacion)
                        LEFT JOIN shared AS tinstitucion ON (tinstitucion.id=proyecto.tinstitucion)
                        LEFT JOIN shared AS onointervencion ON (onointervencion.id=evaluacion.tipo_nointervencion)
                        WHERE departamento.descripcion=@grupo
                        GROUP BY municipio
                        ORDER BY departamento,municipio
                        ;">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="GResultados" Name="grupo" PropertyName="SelectedValue" />
                        </SelectParameters>
    </asp:SqlDataSource>
    </td>
    </tr>
    </table>
    </asp:Panel>
    
    
    <asp:Panel runat="server" ID="PDDepartamento" Visible="false">
    <table>
    <tr>
        <td class="Titulo"><asp:Label runat="server" ID="LDDepartamento"></asp:Label></td>
    </tr>
    <tr>
        <td>
    <asp:GridView ID="GDDepartamento" runat="server" DataSourceID="SDDepartamento" 
        AutoGenerateColumns="False" EmptyDataText="Por favor seleccione un departamento" 
        AllowSorting="True" ShowFooter="True">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="municipio" HeaderText="MUNICIPIO" SortExpression="municipio" ItemStyle-Wrap="false">
                <ItemStyle Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="total" HeaderText="TOTAL " SortExpression="total" 
                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" FooterStyle-Wrap="false"
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="amenor" HeaderText="ADECUACIONES MENORES" 
                SortExpression="amenor" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="amayor" HeaderText="ADECUACIONES MAYORES" 
                SortExpression="amayor" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="dotacion" HeaderText="DOTACION" 
                SortExpression="dotacion" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:c}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="inversion" HeaderText="% INVERSION" 
                SortExpression="inversion" ItemStyle-HorizontalAlign="Right" 
                DataFormatString="{0:p}" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="proyectosrecibidos" HeaderText="PROYECTOS RECIBIDOS" 
                SortExpression="proyectosrecibidos" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="puesto" HeaderText="PUESTO DE SALUD" 
                SortExpression="puesto" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="centro" HeaderText="CENTRO DE SALUD" 
                SortExpression="centro" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="hospital" HeaderText="HOSPITAL LOCAL" 
                SortExpression="hospital" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oimenor" HeaderText="ADECUACIÓN MENOR" 
                SortExpression="oimenor" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oimayor" HeaderText="ADECUACIÓN MAYOR" 
                SortExpression="oimayor" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oidotacion" HeaderText="DOTACION" 
                SortExpression="oidotacion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreposicion" HeaderText="REPOSICION " 
                SortExpression="noreposicion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreubicacion" HeaderText="REUBICACION" 
                SortExpression="noreubicacion" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noreparada" HeaderText="REPARADA" 
                SortExpression="noreparada" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="noviable" HeaderText="NO VIABLE" 
                SortExpression="noviable" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oipdocumentacion" 
                HeaderText="PENDIENTE X DOCUMENTACION" SortExpression="oipdocumentacion" 
                ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" 
                FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>

<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="oipvisita" HeaderText="PENDIENTE X VISITA" 
                SortExpression="oipvisita" ItemStyle-HorizontalAlign="Right" 
                ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right">
<FooterStyle HorizontalAlign="Right"></FooterStyle>
<ItemStyle HorizontalAlign="Right" Wrap="False"></ItemStyle>
            </asp:BoundField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SDDepartamento" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                        municipio.nombre AS municipio
                        ,SUM(evaluacion.presupuesto_inicial) AS total
                        ,SUM(IF(tipoadecuacion.nombre LIKE '%menor%', evaluacion.presupuesto_inicial, 0)) AS amenor
                        ,SUM(IF(tipoadecuacion.nombre LIKE '%mayor%', evaluacion.presupuesto_inicial, 0)) AS amayor
                        ,SUM(IF(evaluacion.dotacion, evaluacion.presupuesto_inicial,0)) AS dotacion
                        ,SUM(evaluacion.presupuesto_inicial)/(SELECT SUM(evaluacion.presupuesto_inicial) FROM evaluacion LEFT JOIN proyecto ON proyecto.id=evaluacion.proyecto LEFT JOIN shared ON proyecto.departamento=shared.id WHERE shared.nombre=@departamento) AS inversion
                        ,COUNT(proyecto.id) AS proyectosrecibidos
                        ,COUNT(IF(tinstitucion.nombre LIKE '%puesto%', 1, NULL)) AS puesto
                        ,COUNT(IF(tinstitucion.nombre LIKE '%centro%', 1, NULL)) AS centro
                        ,COUNT(IF(tinstitucion.nombre LIKE '%hospital%', 1, NULL)) AS hospital
                        ,COUNT(IF(evaluacion.estado=1 AND tipoadecuacion.nombre LIKE '%menor%',1, NULL)) AS oimenor
                        ,COUNT(IF(evaluacion.estado=1 AND tipoadecuacion.nombre LIKE '%mayor%',1, NULL)) AS oimayor
                        ,COUNT(IF(evaluacion.estado=1 AND evaluacion.dotacion,1, NULL)) AS oidotacion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%repos%',1, NULL)) AS noreposicion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%reub%',1, NULL)) AS noreubicacion
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%repara%',1, NULL)) AS noreparada
                        ,COUNT(IF(evaluacion.estado=2 AND onointervencion.nombre LIKE '%viable%',1, NULL)) AS noviable
                        ,COUNT(IF(evaluacion.estado=1 AND onointervencion.nombre LIKE '%documen%',1, NULL)) AS oipdocumentacion
                        ,COUNT(IF(evaluacion.estado=1 AND onointervencion.nombre LIKE '%visita%',1, NULL)) AS oipvisita
                        FROM proyecto
                        LEFT JOIN evaluacion ON (evaluacion.proyecto=proyecto.id) 
                        LEFT JOIN shared AS departamento ON (departamento.id=proyecto.departamento)
                        LEFT JOIN shared AS municipio ON (municipio.id=proyecto.municipio)
                        LEFT JOIN shared AS tipoadecuacion ON (tipoadecuacion.id=evaluacion.adecuacion)
                        LEFT JOIN shared AS tinstitucion ON (tinstitucion.id=proyecto.tinstitucion)
                        LEFT JOIN shared AS onointervencion ON (onointervencion.id=evaluacion.tipo_nointervencion)
                        WHERE departamento.nombre=@departamento
                        GROUP BY municipio
                        ORDER BY departamento,municipio
                        ;">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="GDetalles" Name="departamento" PropertyName="SelectedValue" />
                        </SelectParameters>
    </asp:SqlDataSource>
    </td>
    </tr>
    </table>
    </asp:Panel>
</asp:Content>