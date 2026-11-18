# Gestión de calidad y operaciones web / Web quality and operations management

[Español](#español) · [English](#english)

## Español

Sitio interno para consultar información y documentos de proyectos. Permite que los equipos revisen el avance y encuentren los registros usados en una evaluación.

### Qué puedes hacer

- Consulta proyectos, cantidades de obra y estadísticas.
- Abre evaluaciones y pantallas de seguimiento de proyectos o contratos.
- Consulta archivos de trabajo y revisa cómo se organizan los grupos de acceso.

### Ejemplo

Usa un proyecto ficticio de remodelación y una evaluación de prueba para explorar la ficha, las cantidades y el seguimiento del contrato.

### Cómo empezar

El sitio usa ASP.NET de su época. Revisa las páginas y su código en un entorno Windows compatible con .NET Framework. Para una ejecución local, identifica las conexiones que usa la aplicación y prepara una base vacía con datos de prueba. Las conexiones, recursos y servicios originales se gestionan por separado.

Puntos de entrada en el código. [`inicio.aspx`](inicio.aspx), [`error/Default.aspx`](error/Default.aspx), [`imprimir/Default.aspx`](imprimir/Default.aspx), [`proyectos/Default.aspx`](proyectos/Default.aspx).

Las fechas del historial se apoyan en Git o en la evidencia disponible de los respaldos. Las fechas reconstruidas a partir de archivos sin zona horaria usan las 12:00 UTC como referencia.

## English

An internal site for looking up project records and documents. Teams can review progress and find the material used in an evaluation.

### What you can do

- Review projects, work quantities, and statistics.
- Open evaluations and project or contract tracking screens.
- View working files and explore how access groups are organized.

### Example

Use a fictional remodeling project and sample evaluation to explore its record, quantities, and contract tracking.

### Getting started

The site uses historical ASP.NET. Review its pages and code in a Windows environment compatible with .NET Framework. To run locally, identify the connections the application uses and prepare an empty database with test data. Original connections, resources, and services are managed separately.

Entry points in the source. [`inicio.aspx`](inicio.aspx), [`error/Default.aspx`](error/Default.aspx), [`imprimir/Default.aspx`](imprimir/Default.aspx), [`proyectos/Default.aspx`](proyectos/Default.aspx).

History dates come from Git or available backup evidence. Reconstructed dates from files with no time zone use 12:00 UTC as a reference.
