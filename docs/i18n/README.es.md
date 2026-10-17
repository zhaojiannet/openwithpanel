<p align="center">
  <img src="../assets/icon.png" width="128" alt="Icono de la app OpenWithPanel">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>Elige qué app abre cada cosa en tu Mac, incluidos los archivos con los que macOS no te deja.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 o posterior">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="Licencia MIT">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a> ·
  <b>Español</b> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

OpenWithPanel es una app gratuita y de código abierto para macOS que sirve para gestionar las **apps predeterminadas**: elige, en una sola ventana, qué app abre cada tipo de archivo, cada extensión y cada enlace. Además hace lo que el Finder no puede: convertir tu editor en la app predeterminada para los **archivos sin extensión**, como `.env`, `.gitignore`, `Dockerfile` y `.npmrc`.

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="Ventana principal de OpenWithPanel">
</p>

## Contenido

- [Por qué OpenWithPanel](#por-qué-openwithpanel)
- [Funciones](#funciones)
- [Instalación](#instalación)
- [Uso](#uso)
- [Diagnóstico](#diagnóstico)
- [Ajustes](#ajustes)
- [Modo de desarrollador](#modo-de-desarrollador)
- [Cómo funciona](#cómo-funciona)
- [Preguntas frecuentes](#preguntas-frecuentes)
- [Limitaciones conocidas](#limitaciones-conocidas)
- [Compilar desde el código fuente](#compilar-desde-el-código-fuente)

## Por qué OpenWithPanel

macOS clasifica la mayoría de los archivos sin extensión como `public.data` y se niega a que cualquier app sea la predeterminada para ese tipo. **Obtener información › Abrir con › Cambiar todo…** del Finder no tiene ningún efecto en estos archivos, y las herramientas de línea de comandos fallan con el error `-50`. **Abrir siempre con esta aplicación** del Finder solo se aplica al archivo concreto que hayas seleccionado.

Así que `.env`, `.gitignore`, `Dockerfile` y archivos similares se siguen abriendo en TextEdit —o no se abren en absoluto— hagas lo que hagas. OpenWithPanel lo soluciona con una pequeña app auxiliar llamada OpenWithPanel Helper, que se describe en [Cómo funciona](#cómo-funciona).

También cubre lo que macOS deja fuera en otros aspectos: cuando una app recién instalada (normalmente Xcode) se queda con tus asociaciones de archivo, macOS no te avisa, y no hay ningún botón para dejarlo todo como estaba.

## Funciones

- **Apps predeterminadas por grupo.** Los tipos de archivo se agrupan por finalidad —Texto, Markdown, Código, Configuración y datos, Archivos sin extensión, PDF, Documentos, Imágenes, Vídeo, Audio, Archivos comprimidos— y cada grupo tiene un único menú de app.
- **Aplicar de una vez.** Configura un grupo entero de formatos a la vez sin confirmar uno por uno; los cambios surten efecto en unos segundos.
- **Excepciones por formato.** Despliega un grupo para asignar a un solo formato, como `.md` o `.py`, su propia app. Si más adelante cambias la app del grupo, las excepciones no se tocan.
- **Archivos sin extensión.** Abre `.env`, `Dockerfile`, `.gitignore` y otros archivos sin extensión en el editor que elijas, aunque ese editor no declare que los admite.
- **Extensiones personalizadas.** Añade cualquier extensión que no esté en la lista, incluidas las que macOS solo conoce como tipos temporales, como `.go`, `.rs`, `.kt`, `.dart` y `.lua`.
- **Apps predeterminadas para enlaces.** Elige la app para los enlaces web (`http`, `https`), el correo electrónico (`mailto`), las suscripciones de calendario (`webcal`), las llamadas, los mensajes de texto, FaceTime, SSH, FTP y compartir pantalla, o elige **No abrir** para que hacer clic en ese tipo de enlace no haga nada.
- **Búsqueda por extensión.** Escribe `py` o `env` para ir directamente a la fila correcta.
- **Diagnóstico de cualquier archivo.** Suelta un archivo para ver por qué se abre en una app determinada y elige otra ahí mismo. Suelta una carpeta para encontrar los archivos con su propio ajuste **Abrir con** y borrarlo.
- **Avisos de apropiación.** Si otra app (Xcode, un navegador) se queda con una asociación que configuraste, OpenWithPanel muestra un aviso que la arregla con un clic.
- **Deshacer y restaurar.** Antes de cada cambio se guarda una instantánea. Deshaz con `⌘Z`, restaura cualquier instantánea anterior o devuélvelo todo a como estaba antes de que OpenWithPanel cambiara nada, con una vista previa de cada cambio antes.
- **Reglas de carpeta.** Una alternativa opcional que hace que los archivos sin extensión de las carpetas que elijas, como `~/Projects`, se abran en tu editor, usando solo API oficiales de macOS.
- **Modo de desarrollador.** Reglas que dirigen los archivos según un patrón de nombre (por ejemplo, `Dockerfile*`), una carpeta o si el contenido es texto o binario; la cadena de decisión completa en el diagnóstico, incluidos los tipos que declara cada app y su rango; importación y exportación de preajustes.
- **Desinstalación limpia.** El desinstalador integrado devuelve cada asociación a su app original antes de trasladar OpenWithPanel a la Papelera.
- **15 idiomas.** Inglés, chino simplificado, chino tradicional, japonés, coreano, alemán, francés, español, portugués, indonesio, tailandés, vietnamita, árabe, ruso e hindi, que puedes cambiar dentro de la app.

## Instalación

Requiere macOS 26 Tahoe o posterior.

1. Abre la [página de Releases](https://github.com/zhaojiannet/openwithpanel/releases) y, en **Assets** de la última versión, descarga `OpenWithPanel-<version>.dmg`.
2. Haz doble clic en el DMG descargado para abrirlo.
3. Arrastra **OpenWithPanel** a la carpeta **Aplicaciones** que aparece en la misma ventana.
4. Expulsa el DMG y abre OpenWithPanel desde la carpeta Aplicaciones. La primera vez, macOS te pide que lo permitas; consulta [Primer arranque](#primer-arranque).

No hay instalador y no hace falta contraseña de administrador.

**Actualizar:** descarga el nuevo DMG y vuelve a arrastrar OpenWithPanel a Aplicaciones, sustituyendo la copia antigua. Tus ajustes, reglas e instantáneas se conservan.

**Desinstalar:** consulta [Desinstalación](#desinstalación).

### Primer arranque

OpenWithPanel aún no está notarizado por Apple, así que macOS lo bloquea la primera vez que lo abres. Permítelo una vez:

1. Haz doble clic en OpenWithPanel. Cuando macOS diga que no ha podido verificar OpenWithPanel, haz clic en **Aceptar**. No hagas clic en el botón azul **Trasladar a la Papelera**.

   <img src="../assets/first-launch-1.png" width="372" alt="El primer aviso: haz clic en Aceptar">

2. Abre **Ajustes del Sistema › Privacidad y seguridad**, desplázate hasta **Seguridad** y haz clic en **Abrir igualmente** junto a OpenWithPanel. El botón está disponible durante aproximadamente una hora después del paso 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Privacidad y seguridad: haz clic en Abrir igualmente">

3. Introduce tu contraseña de inicio de sesión o usa Touch ID. En el cuadro de diálogo que aparece a continuación, vuelve a hacer clic en **Abrir igualmente**.

   <img src="../assets/first-launch-3.png" width="372" alt="La confirmación: haz clic en Abrir igualmente">

A partir de entonces, OpenWithPanel se abre con normalidad. Su app auxiliar integrada queda permitida junto con él, así que los archivos sin extensión se abren sin más avisos. El DMG también incluye estos pasos en `First Launch.txt`. Las capturas muestran la interfaz en inglés; en macOS en español, los botones se llaman como se indica arriba.

## Uso

### Grupos de tipos de archivo

La pestaña **Tipos de archivo** muestra cada grupo como una tarjeta:

| Grupo | Incluye |
|---|---|
| Texto | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| Código | Lenguajes de programación populares, ver más abajo |
| Configuración y datos | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| Archivos sin extensión | `.env` `Dockerfile` `.gitignore` y similares |
| PDF | `.pdf` |
| Documentos | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| Imágenes, Vídeo, Audio, Archivos comprimidos | Sus formatos habituales |
| Personalizado | Extensiones que has añadido y que no encajan en ningún otro grupo; solo aparece si tiene alguna |

El grupo Código abarca los lenguajes que usa al menos el 5 % de los encuestados en la Stack Overflow 2025 Developer Survey: JavaScript, TypeScript (`.tsx`), Python, Java, C, C++, C#, PHP, Ruby, Swift, Go, Rust, Kotlin, Dart, Lua, Shell (sh, bash, zsh), PowerShell, SQL y ensamblador, además de CSS, Makefile y JSX. Puedes añadir otros tú mismo; consulta [Añadir una extensión](#añadir-una-extensión).

### Asignar una app a un grupo entero

Elige una app en el menú situado a la derecha de una tarjeta. A partir de ese momento, todos los formatos del grupo se abren con ella. El menú muestra las apps que macOS considera capaces de abrir el grupo; elige **Otra…** para escoger cualquier app de la carpeta Aplicaciones.

### Dar a un formato su propia app

Haz clic en la fila de un grupo, o en la flecha de su izquierda, para desplegarlo. Cada formato tiene su propia fila, con el icono del sistema para ese archivo y su extensión como título. Elige otra app en el menú de una fila y ese formato la usará desde entonces; la fila se marca como **Ajuste propio** y la fila del grupo indica cuántos formatos tienen ajuste propio.

- Un formato sin app propia muestra **Igual que el grupo** en gris en su menú.
- Para que un formato vuelva a seguir al grupo, elige **Seguir al grupo** en su menú.
- Si más adelante cambias la app del grupo, los formatos con app propia no se tocan.

Los grupos de más de 8 formatos solo muestran los formatos con ajuste propio o los que has añadido tú; **Mostrar los N formatos**, al final, muestra el resto. Cuando el grupo Código lo muestra todo, se divide en secciones como Web, Sistemas y apps, JVM y Scripts y shell.

### Buscar

Escribe una extensión, como `py` o `env`, en el campo de búsqueda de arriba a la derecha. El grupo correspondiente se despliega con todos sus formatos y la fila que coincide se resalta. Si la extensión no está en ningún grupo, el resultado de la búsqueda ofrece **Añadir…**.

### Añadir una extensión

Usa **Añadir extensión…** al final de la lista, o **Añadir…** en un resultado de búsqueda.

1. Escribe la extensión, como `nim`. La hoja muestra cómo la reconoce macOS.
2. Según eso, OpenWithPanel sugiere un grupo: el código fuente va a Código, las imágenes a Imágenes y todo lo que no se reconoce a Personalizado. Puedes elegir otro grupo.
3. Haz clic en **Añadir**. El formato aparece en ese grupo, marcado como **Personalizado**, y sigue la app del grupo; también puedes darle su propia app.

Una extensión que ya está en un grupo no se añade dos veces; la hoja te indica en qué grupo está. Los formatos que has añadido tienen un botón para eliminarlos en su fila.

### Aplicar

Todos los cambios anteriores quedan primero pendientes. Una barra en la parte inferior de la ventana muestra cuántos cambios hay pendientes; **Aplicar** hace que surtan efecto y **Descartar** los desecha.

- Los cambios de tipos de archivo no piden confirmación. Cambies los formatos que cambies, OpenWithPanel los escribe de una vez en las preferencias del sistema y hace que el sistema los recargue una sola vez; todo surte efecto en unos segundos.
- Los cambios de enlaces y de archivos web (`.html`) siguen pidiendo que confirmes en un cuadro de diálogo del sistema, por ejemplo cuando cambias de navegador web. Cambiar el navegador sin avisar es lo que hacen los secuestradores de navegador, así que macOS debe preguntarte directamente.
- Si la escritura falla (por ejemplo, por permisos) o un formato no surte efecto, OpenWithPanel lo vuelve a configurar mediante la API del sistema, uno por uno; macOS te pregunta entonces si quieres usar la nueva app o mantener la anterior. Si mantienes la anterior, OpenWithPanel registra ese formato con ajuste propio para esa app y no vuelve a tocarlo.
- Después de aplicar, OpenWithPanel vuelve a leer el estado real del sistema, así que la lista siempre muestra lo que de verdad ha surtido efecto.

### Deshacer y restaurar

- **Edición › Deshacer** (`⌘Z`) deshace la última aplicación. Puedes deshacer varias veces seguidas.
- El botón de flecha circular de la barra de herramientas es **Restaurar estado inicial**: cada tipo de archivo y enlace que OpenWithPanel cambió vuelve a apuntar a la app que usaba cuando abriste OpenWithPanel por primera vez. Antes de que ocurra nada se muestra la lista de cambios.

macOS no permite eliminar una asociación de archivo, solo hacer que apunte a otra app, así que restaurar significa hacer que cada tipo vuelva a apuntar a la app registrada en la instantánea. Un tipo para el que macOS elegía la app por su cuenta recibe después un ajuste explícito para esa misma app; se abre exactamente igual que antes.

### Enlaces

Debajo de los tipos de archivo, una tarjeta define la app para cada tipo de enlace:

| Fila | Esquemas de URL |
|---|---|
| Navegador web | `http:` `https:` |
| Correo electrónico | `mailto:` |
| Suscripciones de calendario | `webcal:` |
| Llamadas, Mensajes de texto, FaceTime | `tel:` `sms:` `facetime:` |
| SSH, FTP, Compartir pantalla | `ssh:` `ftp:` `vnc:` |

Aparece cada tipo de enlace que alguna app de tu Mac sabe gestionar. Al final de cada menú está **No abrir**: elígelo y hacer clic en ese tipo de enlace, en cualquier app, no hará nada; por ejemplo, para que un número de teléfono de una página web no inicie una llamada. Para deshacerlo, vuelve a elegir una app en el menú. Elegir **No abrir** para el navegador web pide confirmación antes, ya que no se abriría ningún enlace web. También puedes buscar un esquema (como `mailto`) o el nombre de una fila.

Los enlaces quedan pendientes, se aplican, se guardan en instantáneas, se deshacen y se restauran igual que los tipos de archivo. Cambiar el navegador web pide confirmación en un cuadro de diálogo del sistema; en macOS 27, cambiar `http` también cambia `https`, y OpenWithPanel no vuelve a configurar `https`, así que solo confirmas una vez.

## Diagnóstico

Cambia a la pestaña **Diagnóstico** en la parte superior de la ventana.

**¿Por qué se abre un archivo en esta app?** Suelta un archivo en el recuadro discontinuo. El resultado muestra qué app lo abre y por qué:

- el archivo tiene su propio ajuste **Abrir con**, hecho en **Obtener información** del Finder;
- OpenWithPanel Helper lo recibió y una regla o un ajuste de grupo lo envió a una app;
- elegiste esta app para este tipo de archivo;
- no había nada configurado, así que macOS eligió la app.

Debajo del resultado, **Usar en su lugar** cambia directamente a otra app. Si el archivo tiene su propio ajuste **Abrir con**, aparece en su lugar **Eliminar el ajuste propio de este archivo**.

**Buscar archivos con su propio ajuste «Abrir con».** Suelta una carpeta en el recuadro discontinuo. OpenWithPanel muestra cada archivo de esa carpeta que tiene su propio ajuste **Abrir con**, junto con la app a la que apunta. Selecciona archivos y haz clic en **Eliminar sus propios ajustes**; a partir de entonces siguen el ajuste de su tipo. El análisis omite las carpetas `.git`, `node_modules`, `.build`, `DerivedData`, `Pods`, `vendor`, `.venv` y `__pycache__`.

**Exportar un informe de diagnóstico.** **Exportar informe de diagnóstico…**, al final de la pestaña, guarda un informe de texto con tu configuración, qué app abre actualmente cada tipo que gestiona OpenWithPanel, el registro de esta sesión y el archivo que acabas de diagnosticar. Envíaselo al desarrollador cuando informes de un problema.

## Ajustes

Abre **OpenWithPanel › Ajustes…** o pulsa `⌘,`.

**General**

- **Idioma:** elige **Igual que el sistema** o uno de los 15 idiomas y haz clic en **Reabrir ahora**. Si hay cambios sin aplicar, aplícalos o descártalos primero.
- **Modo de desarrollador:** muestra más detalles; consulta [Modo de desarrollador](#modo-de-desarrollador). Solo cambia lo que se muestra, nunca tus ajustes.

**Reglas de carpeta**

Una alternativa para cuando el método usado para los archivos sin extensión deja de funcionar. Añade una carpeta y elige una app, y OpenWithPanel dará a cada archivo de texto sin extensión de esa carpeta su propio ajuste **Abrir con** para esa app.

- Los archivos binarios y los que hayas configurado tú mismo no se tocan.
- Los archivos nuevos se procesan cada vez que abres OpenWithPanel, o al momento con **Aplicar ahora**.
- **Deshacer todos los ajustes de carpeta** deja cada archivo que OpenWithPanel cambió como estaba.
- **Omitir carpetas llamadas** se puede editar; por defecto incluye las carpetas que omite el análisis de carpetas de Diagnóstico.

**Historial**

Muestra la instantánea guardada antes de cada aplicación, hasta 20, de la más reciente a la más antigua. La última, **Inicial (antes de que OpenWithPanel cambiara nada)**, es el estado registrado la primera vez que abriste OpenWithPanel. Cualquiera de ellas se puede restaurar con **Restaurar…**, con una vista previa de las diferencias antes.

**Lo que ha escrito OpenWithPanel**

Muestra cada lugar que OpenWithPanel cambia o en el que escribe en tu Mac, cada uno con **Mostrar en el Finder**:

- **Asociaciones de archivo:** cuántos elementos (tipos de archivo y enlaces) gestiona OpenWithPanel;
- **Entradas de preferencias de LaunchServices:** las entradas que OpenWithPanel escribió para los tipos de archivo, incluidos los archivos sin extensión;
- **OpenWithPanel Helper:** dentro de la app OpenWithPanel;
- **Reglas e instantáneas:** `~/Library/Application Support/net.zhaojian.openwithpanel/`;
- **Ajustes «Abrir con» por archivo:** solo existen si has usado reglas de carpeta.

OpenWithPanel no se ejecuta en segundo plano, no tiene ítem de inicio, no establece conexiones de red y no recopila datos.

### Desinstalación

Al final de **Lo que ha escrito OpenWithPanel**, haz clic en **Desinstalar OpenWithPanel…** y elige si quieres eliminar también las reglas y las instantáneas. Entonces OpenWithPanel:

1. hace que cada tipo de archivo y enlace que cambió vuelva a apuntar a su app original;
2. deshace cada ajuste por archivo hecho por las reglas de carpeta;
3. elimina o conserva `~/Library/Application Support/net.zhaojian.openwithpanel/`, según hayas elegido;
4. se traslada a sí mismo a la Papelera.

Si algún tipo de archivo o enlace no puede volver a apuntar a su app original —por ejemplo, porque rechazaste una confirmación del sistema—, la desinstalación se detiene y no se elimina nada.

Si conservas las reglas y las instantáneas, al reinstalar OpenWithPanel aparece un aviso que restaura todos tus ajustes con un clic. Las herramientas de limpieza que eliminan los archivos sobrantes de una app al trasladarla a la Papelera también pueden eliminar las reglas y las instantáneas que decidiste conservar; indica a esa herramienta que omita OpenWithPanel.

Si en lugar de eso arrastras tú mismo OpenWithPanel a la Papelera, OpenWithPanel Helper se va con él y macOS descarta las asociaciones que apuntaban a él; los demás tipos conservan las apps que configuró OpenWithPanel. Un archivo `UNINSTALL.txt` en la carpeta Application Support explica cómo restaurarlas en ese caso.

## Modo de desarrollador

Actívalo en **Ajustes › General**. Añade:

- el identificador de tipo del sistema (UTI) debajo de cada formato, y una etiqueta **Asistente** en los formatos que pasan por OpenWithPanel Helper;
- la cadena de decisión completa en el diagnóstico: tipo, tipos padre, texto o binario, la decisión y cómo lo declara en su Info.plist cada app que puede abrir el archivo (extensión o tipo coincidente, rol y rango);
- una pestaña **Reglas** en la ventana principal;
- el tratamiento de los **Archivos que no son texto** y los **Preajustes** en los ajustes.

Las **Reglas** deciden adónde envía OpenWithPanel Helper los archivos que recibe. Una regla tiene:

- condiciones, de las que hay que rellenar al menos una: un patrón de nombre de archivo (como `Dockerfile*`, sin distinguir mayúsculas y minúsculas), una carpeta contenedora (como `~/Projects`) y si el contenido es texto o binario;
- los tipos a los que se aplica, `public.data` (archivos sin extensión) por defecto; los demás tipos que añadas también pasan por OpenWithPanel Helper;
- adónde enviar el archivo: una app, **Mostrar en el Finder** o la **App original**.

Las reglas se comprueban de arriba abajo y gana la primera que coincide. Arrastra para reordenarlas; el interruptor de la izquierda desactiva una regla temporalmente. Los grupos afectados por reglas muestran **Controlado por reglas** en el modo estándar.

**Archivos que no son texto** define qué hace OpenWithPanel Helper con los archivos binarios: **Mostrar en el Finder** (por defecto), **Abrir con la misma app** o **Abrir con la app original**.

**Preajustes** exporta tus ajustes de grupo, tus ajustes por formato, tus extensiones personalizadas y tus reglas a un archivo JSON que puedes importar en otro Mac; los ajustes importados surten efecto después de hacer clic en **Aplicar**. Las reglas de carpeta y los registros de la app original son propios de cada Mac, así que ni se exportan ni se sobrescriben al importar.

## Cómo funciona

OpenWithPanel incluye una diminuta app auxiliar, **OpenWithPanel Helper**, dentro de su paquete de app. Cuando eliges un editor para los archivos sin extensión, OpenWithPanel hace que `public.data` apunte a la app auxiliar. Cuando abres uno de esos archivos, la app auxiliar comprueba tus reglas y el contenido del archivo, entrega los archivos de texto a la app que elegiste, muestra los archivos binarios en el Finder y se cierra. No se queda en ejecución: macOS solo la inicia cuando tiene un archivo o un enlace que entregar, y se cierra tras menos de un segundo de inactividad. No tiene ventana y no aparece en el Dock. Los enlaces configurados como **No abrir** también se envían a la app auxiliar, que simplemente los ignora.

Un archivo se considera binario si sus primeros 8 KB contienen un byte nulo o no son UTF-8 válido.

Los tipos de archivo que la app elegida ya admite, como `.md` o `.py`, se asignan a esa app directamente, sin la app auxiliar.

macOS no ofrece ninguna API pública para definir una app predeterminada para `public.data`, y desde macOS 26.4 su API pública pide confirmación por cada tipo de archivo que cambies. Por eso OpenWithPanel escribe todos los cambios de tipos de archivo de una vez en las preferencias de LaunchServices y reinicia el servicio `lsd` una vez para que surtan efecto. Apple no documenta este mecanismo y puede dejar de funcionar tras una actualización del sistema. Si un cambio no surte efecto, OpenWithPanel recurre a la API pública, que te pide confirmación; para los archivos sin extensión, ofrece en su lugar las reglas de carpeta.

## Preguntas frecuentes

**¿Cómo cambio la app predeterminada para los archivos sin extensión en un Mac?**
Abre OpenWithPanel, elige una app para **Archivos sin extensión** y pulsa **Aplicar**. A partir de entonces, archivos como `.env` y `Dockerfile` se abren en esa app.

**¿Por qué no funciona «Cambiar todo» del Finder con los archivos `.env`?**
macOS los trata como datos genéricos (`public.data`) y bloquea el cambio de la app predeterminada para ese tipo mediante sus API públicas. OpenWithPanel lo sortea con su app auxiliar.

**¿Cómo hago que VS Code, Zed o Sublime Text sea el editor predeterminado para los archivos de código?**
Elige el editor para el grupo **Código**, o para formatos concretos, y pulsa **Aplicar**. También se cubren las extensiones sin un tipo oficial de macOS, como `.go` y `.rs`.

**¿Puedo deshacerlo todo?**
Sí. OpenWithPanel registra las asociaciones originales la primera vez que se ejecuta y nunca sobrescribe ese registro. **Restaurar estado inicial** hace que cada tipo cambiado vuelva a apuntar a su app original.

**¿OpenWithPanel recopila datos o se ejecuta en segundo plano?**
No. No establece conexiones de red, no recopila datos, no instala agentes en segundo plano y no sigue en ejecución después de que lo cierres. **Ajustes › Lo que ha escrito OpenWithPanel** muestra cada lugar en el que escribe.

**¿Por qué OpenWithPanel no usa el sandbox?**
macOS no permite que las apps en sandbox cambien las apps predeterminadas. En su lugar, OpenWithPanel usa el hardened runtime.

## Limitaciones conocidas

- En macOS, `.ts` se reconoce como un formato de vídeo (flujo de transporte MPEG-2), y cambiarlo afectaría a archivos de vídeo reales, así que el grupo Código solo cubre el `.tsx` de TypeScript. Del mismo modo, para macOS `.r`, `.exs` y `.fs` son recursos de Rez, archivos del sampler de Logic y shaders, y no están en el grupo Código.
- Los ajustes de tipos de archivo dependen de un mecanismo del sistema no documentado que puede dejar de funcionar tras una actualización del sistema. Si ocurre, los tipos de archivo normales recurren automáticamente a la API del sistema (una confirmación por tipo), y los archivos sin extensión pueden usar en su lugar las reglas de carpeta.
- macOS solo permite que una app lea el registro de su propio proceso, así que el informe de diagnóstico no incluye el registro de OpenWithPanel Helper. Busca `net.zhaojian.openwithpanel` en la app Consola si lo necesitas.
- Las traducciones de la interfaz aún no las han revisado hablantes nativos.

## Compilar desde el código fuente

Requiere Xcode 27.

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

Para crear un DMG:

```sh
scripts/package.sh
```

El resultado se guarda en `.build/dist/`, junto con un cask de Homebrew generado a partir de `packaging/openwithpanel.rb` con la versión y la suma de comprobación ya rellenadas. Sin variables de entorno, la app se firma ad hoc y no se notariza; en ese caso el DMG incluye `First Launch.txt`. Define `DEVELOPER_ID` (el nombre de un certificado Developer ID Application) para firmar con él, y define también `NOTARY_PROFILE` (un perfil de credenciales guardado con `xcrun notarytool store-credentials`) para notarizar y grapar el ticket (staple).

Las versiones las compila el flujo de trabajo de GitHub Actions de `.github/workflows/release.yml`. Cómo firma y cómo publicar una versión se describe en [docs/release.md](../release.md).

## Estructura del proyecto

- `OpenWithPanelKit/`: un paquete Swift local. `OpenWithPanelCore` contiene toda la lógica; `OpenWithPanelPlatform` envuelve las API del sistema.
- `Apps/OpenWithPanel/`: la app principal (SwiftUI).
- `Apps/Helper/`: la app auxiliar integrada en el paquete de la app principal.
- `scripts/`, `packaging/`: el script de empaquetado y la plantilla del cask de Homebrew.

## Licencia

[MIT](../../LICENSE) © 2026 zhaoJian
