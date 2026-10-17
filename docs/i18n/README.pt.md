<p align="center">
  <img src="../assets/icon.png" width="128" alt="Ícone do app OpenWithPanel">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>Defina qual app abre cada coisa no seu Mac — inclusive os arquivos que o macOS não deixa.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 ou posterior">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="Licença MIT">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.es.md">Español</a> ·
  <b>Português</b> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

O OpenWithPanel é um app gratuito e de código aberto para macOS que gerencia os **apps padrão**: escolha, em uma única janela, qual app abre cada tipo de arquivo, cada extensão e cada link. Ele também faz o que o Finder não consegue: tornar o seu editor o app padrão para **arquivos sem extensão**, como `.env`, `.gitignore`, `Dockerfile` e `.npmrc`.

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="Janela principal do OpenWithPanel">
</p>

## Sumário

- [Por que o OpenWithPanel](#por-que-o-openwithpanel)
- [Recursos](#recursos)
- [Instalação](#instalação)
- [Uso](#uso)
- [Diagnóstico](#diagnóstico)
- [Ajustes](#ajustes)
- [Modo de desenvolvedor](#modo-de-desenvolvedor)
- [Como funciona](#como-funciona)
- [Perguntas frequentes](#perguntas-frequentes)
- [Limitações conhecidas](#limitações-conhecidas)
- [Compilar a partir do código-fonte](#compilar-a-partir-do-código-fonte)

## Por que o OpenWithPanel

O macOS classifica a maioria dos arquivos sem extensão como `public.data` e se recusa a deixar qualquer app se tornar o padrão para esse tipo. **Obter Informações › Abrir Com › Alterar Tudo…** do Finder não tem efeito nesses arquivos, e as ferramentas de linha de comando falham com o erro `-50`. **Sempre Abrir Com** do Finder só vale para o arquivo que você selecionou.

Por isso, `.env`, `.gitignore`, `Dockerfile` e arquivos parecidos continuam abrindo no TextEdit — ou nem abrem — não importa o que você configure. O OpenWithPanel resolve isso com um pequeno app auxiliar chamado OpenWithPanel Helper, descrito em [Como funciona](#como-funciona).

Ele também cobre o que o macOS deixa de fora em outros pontos: quando um app recém-instalado (normalmente o Xcode) toma as suas associações de arquivo, o macOS não avisa, e não existe um botão para deixar tudo como estava.

## Recursos

- **Apps padrão por grupo.** Os tipos de arquivo são agrupados por finalidade — Texto, Markdown, Código, Configuração e dados, Arquivos sem extensão, PDF, Documentos, Imagens, Vídeo, Áudio, Arquivos compactados — e cada grupo tem um único menu de app.
- **Aplicar de uma vez.** Configure um grupo inteiro de formatos de uma só vez, sem confirmar um por um; as alterações entram em vigor em poucos segundos.
- **Exceções por formato.** Expanda um grupo para dar a um único formato, como `.md` ou `.py`, o seu próprio app. Mudar depois o app do grupo não mexe nas exceções.
- **Arquivos sem extensão.** Abra `.env`, `Dockerfile`, `.gitignore` e outros arquivos sem extensão no editor que você escolher, mesmo que esse editor não declare suporte a eles.
- **Extensões personalizadas.** Adicione qualquer extensão que não esteja na lista, inclusive as que o macOS só conhece como tipos temporários, como `.go`, `.rs`, `.kt`, `.dart` e `.lua`.
- **Apps padrão para links.** Escolha o app para links da web (`http`, `https`), e-mail (`mailto`), assinaturas de calendário (`webcal`), chamadas, mensagens de texto, FaceTime, SSH, FTP e compartilhamento de tela — ou escolha **Não abrir** para que clicar nesse tipo de link não faça nada.
- **Busca por extensão.** Digite `py` ou `env` para ir direto à linha certa.
- **Diagnóstico de qualquer arquivo.** Solte um arquivo para ver por que ele abre em determinado app e escolha outro ali mesmo. Solte uma pasta para encontrar arquivos com ajuste próprio de **Abrir Com** e removê-lo.
- **Alertas de tomada.** Se outro app (o Xcode, um navegador) tomar uma associação que você definiu, o OpenWithPanel mostra um aviso que corrige com um clique.
- **Desfazer e restaurar.** Um instantâneo é salvo antes de cada alteração. Desfaça com `⌘Z`, restaure qualquer instantâneo anterior ou volte tudo para como estava antes de o OpenWithPanel alterar qualquer coisa, com uma prévia de cada alteração antes.
- **Regras de pasta.** Uma alternativa opcional que faz os arquivos sem extensão de pastas escolhidas, como `~/Projects`, abrirem no seu editor, usando apenas APIs oficiais do macOS.
- **Modo de desenvolvedor.** Regras que encaminham arquivos por padrão de nome (por exemplo, `Dockerfile*`), pasta ou conteúdo texto versus binário; a cadeia de decisão completa no diagnóstico, incluindo os tipos declarados por cada app e o rank; importação e exportação de predefinições.
- **Desinstalação limpa.** O desinstalador integrado devolve cada associação ao app original antes de mover o OpenWithPanel para o Lixo.
- **15 idiomas.** Inglês, chinês simplificado, chinês tradicional, japonês, coreano, alemão, francês, espanhol, português, indonésio, tailandês, vietnamita, árabe, russo e hindi, com troca de idioma dentro do app.

## Instalação

Requer macOS 26 Tahoe ou posterior.

1. Abra a [página de Releases](https://github.com/zhaojiannet/openwithpanel/releases) e, em **Assets** da versão mais recente, baixe `OpenWithPanel-<version>.dmg`.
2. Clique duas vezes no DMG baixado para abri-lo.
3. Arraste o **OpenWithPanel** para a pasta **Aplicativos** mostrada na mesma janela.
4. Ejete o DMG e abra o OpenWithPanel pela pasta Aplicativos. Na primeira vez, o macOS pede que você o permita; veja [Primeira abertura](#primeira-abertura).

Não há instalador e não é preciso senha de administrador.

**Atualizar:** baixe o novo DMG e arraste o OpenWithPanel para Aplicativos de novo, substituindo a cópia antiga. Seus ajustes, regras e instantâneos são mantidos.

**Desinstalar:** veja [Desinstalação](#desinstalação).

### Primeira abertura

O OpenWithPanel ainda não é notarizado pela Apple, então o macOS o bloqueia na primeira vez que você o abre. Permita uma vez:

1. Clique duas vezes no OpenWithPanel. Quando o macOS disser que não pôde verificar o OpenWithPanel, clique em **OK**. Não clique no botão azul **Mover para o Lixo**.

   <img src="../assets/first-launch-1.png" width="372" alt="O primeiro aviso: clique em OK">

2. Abra **Ajustes › Privacidade e Segurança**, role até **Segurança** e clique em **Abrir Mesmo Assim** ao lado do OpenWithPanel. O botão fica disponível por cerca de uma hora após o passo 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Privacidade e Segurança: clique em Abrir Mesmo Assim">

3. Digite sua senha de login ou use o Touch ID. Na caixa de diálogo seguinte, clique em **Abrir Mesmo Assim** de novo.

   <img src="../assets/first-launch-3.png" width="372" alt="A confirmação: clique em Abrir Mesmo Assim">

Depois disso, o OpenWithPanel abre normalmente. O app auxiliar integrado é permitido junto com ele, então os arquivos sem extensão abrem sem novos avisos. O DMG também traz esses passos em `First Launch.txt`. As capturas de tela mostram a interface em inglês; no macOS em português, os botões têm os nomes indicados acima.

## Uso

### Grupos de tipos de arquivo

A aba **Tipos de arquivo** lista cada grupo como um cartão:

| Grupo | Inclui |
|---|---|
| Texto | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| Código | Linguagens de programação populares, veja abaixo |
| Configuração e dados | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| Arquivos sem extensão | `.env` `Dockerfile` `.gitignore` e semelhantes |
| PDF | `.pdf` |
| Documentos | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| Imagens, Vídeo, Áudio, Arquivos compactados | Seus formatos comuns |
| Personalizado | Extensões que você adicionou e que não se encaixam em nenhum outro grupo; só aparece quando tem alguma |

O grupo Código cobre as linguagens usadas por pelo menos 5% dos participantes da Stack Overflow 2025 Developer Survey: JavaScript, TypeScript (`.tsx`), Python, Java, C, C++, C#, PHP, Ruby, Swift, Go, Rust, Kotlin, Dart, Lua, Shell (sh, bash, zsh), PowerShell, SQL e assembly, além de CSS, Makefile e JSX. Adicione outras você mesmo; veja [Adicionar uma extensão](#adicionar-uma-extensão).

### Definir um app para um grupo inteiro

Escolha um app no menu à direita de um cartão. A partir daí, todos os formatos do grupo abrem nele. O menu lista os apps que o macOS considera capazes de abrir o grupo; escolha **Outro…** para selecionar qualquer app da pasta Aplicativos.

### Dar a um formato o seu próprio app

Clique na linha de um grupo, ou na seta à esquerda dela, para expandi-lo. Cada formato tem a sua própria linha, com o ícone do sistema para aquele arquivo e a extensão como título. Escolha outro app no menu de uma linha e esse formato passa a usá-lo; a linha recebe a marca **Ajuste próprio**, e a linha do grupo mostra quantos formatos têm ajuste próprio.

- Um formato sem app próprio mostra **Igual ao grupo** em cinza no menu.
- Para que um formato volte a seguir o grupo, escolha **Seguir o grupo** no menu dele.
- Mudar depois o app do grupo não mexe nos formatos que têm app próprio.

Grupos com mais de 8 formatos mostram apenas os formatos com ajuste próprio ou adicionados por você; **Mostrar todos os N formatos**, no fim, lista o restante. Quando o grupo Código mostra tudo, ele é dividido em seções como Web, Sistemas e apps, JVM e Scripts e shell.

### Busca

Digite uma extensão, como `py` ou `env`, no campo de busca no canto superior direito. O grupo correspondente é expandido com todos os formatos e a linha correspondente fica destacada. Se a extensão não estiver em nenhum grupo, o resultado da busca oferece **Adicionar…**.

### Adicionar uma extensão

Use **Adicionar extensão…** no fim da lista, ou **Adicionar…** em um resultado de busca.

1. Digite a extensão, como `nim`. A folha mostra como o macOS a reconhece.
2. Com base nisso, o OpenWithPanel sugere um grupo: código-fonte vai para Código, imagens para Imagens e qualquer coisa não reconhecida para Personalizado. Você pode escolher outro grupo.
3. Clique em **Adicionar**. O formato aparece nesse grupo, marcado como **Personalizado**, e segue o app do grupo; você também pode dar a ele um app próprio.

Uma extensão que já está em um grupo não é adicionada duas vezes; a folha informa em qual grupo ela está. Os formatos que você adicionou têm um botão de remover na linha.

### Aplicar

Todas as alterações acima ficam primeiro pendentes. Uma barra na parte inferior da janela mostra quantas alterações estão pendentes; **Aplicar** faz com que entrem em vigor e **Descartar** as descarta.

- As alterações de tipos de arquivo não pedem confirmação. Não importa quantos formatos você altere, o OpenWithPanel grava todos de uma vez nas preferências do sistema e faz o sistema recarregá-las uma única vez; tudo entra em vigor em poucos segundos.
- As alterações de links e de arquivos da web (`.html`) continuam pedindo confirmação em uma caixa de diálogo do sistema, por exemplo quando você troca de navegador. Trocar o navegador sem avisar é o que fazem os sequestradores de navegador, então o macOS deve perguntar diretamente a você.
- Se a gravação falhar (por exemplo, por causa de permissões) ou um formato não entrar em vigor, o OpenWithPanel o define de novo pela API do sistema, um por um; o macOS então pergunta se deve usar o novo app ou manter o antigo. Se você mantiver o antigo, o OpenWithPanel registra esse formato com ajuste próprio para esse app e não mexe mais nele.
- Depois de aplicar, o OpenWithPanel lê de volta o estado real do sistema, então a lista sempre mostra o que de fato entrou em vigor.

### Desfazer e restaurar

- **Editar › Desfazer** (`⌘Z`) desfaz a última aplicação. Você pode desfazer várias vezes seguidas.
- O botão de seta circular na barra de ferramentas é **Restaurar o estado inicial**: cada tipo de arquivo e link que o OpenWithPanel alterou volta a apontar para o app que usava quando você abriu o OpenWithPanel pela primeira vez. Cada alteração é listada antes que qualquer coisa aconteça.

O macOS não tem como remover uma associação de arquivo, apenas apontá-la para outro app, então restaurar significa apontar cada tipo de volta para o app registrado no instantâneo. Um tipo para o qual o macOS escolhia o app por conta própria passa a ter um ajuste explícito para esse mesmo app; ele abre exatamente como antes.

### Links

Abaixo dos tipos de arquivo, um cartão define o app para cada tipo de link:

| Linha | Esquemas de URL |
|---|---|
| Navegador | `http:` `https:` |
| E-mail | `mailto:` |
| Assinaturas de calendário | `webcal:` |
| Chamadas, Mensagens de texto, FaceTime | `tel:` `sms:` `facetime:` |
| SSH, FTP, Compartilhamento de tela | `ssh:` `ftp:` `vnc:` |

Todo tipo de link que algum app do seu Mac sabe tratar aparece na lista. No fim de cada menu está **Não abrir**: escolha essa opção e clicar nesse tipo de link, em qualquer app, não faz nada — por exemplo, para que um número de telefone em uma página da web não inicie uma chamada. Para desfazer, escolha um app no menu de novo. Escolher **Não abrir** para o navegador pede confirmação antes, já que nenhum link da web abriria. Você também pode buscar um esquema (como `mailto`) ou o nome de uma linha.

Os links ficam pendentes, são aplicados, entram nos instantâneos, são desfeitos e restaurados exatamente como os tipos de arquivo. Trocar o navegador pede confirmação em uma caixa de diálogo do sistema; no macOS 27, alterar `http` também altera `https`, e o OpenWithPanel então não define `https` de novo, então você confirma só uma vez.

## Diagnóstico

Vá para a aba **Diagnóstico** na parte superior da janela.

**Por que um arquivo abre neste app?** Solte um arquivo na caixa tracejada. O resultado mostra qual app o abre e por quê:

- o arquivo tem o seu próprio ajuste de **Abrir Com**, feito em **Obter Informações** do Finder;
- o OpenWithPanel Helper o recebeu e uma regra ou um ajuste de grupo o enviou para um app;
- você escolheu este app para este tipo de arquivo;
- nada foi definido, então o macOS escolheu o app.

Abaixo do resultado, **Usar em vez disso** troca diretamente para outro app. Se o arquivo tiver o seu próprio ajuste de **Abrir Com**, aparece **Remover o ajuste próprio deste arquivo** no lugar.

**Encontrar arquivos com ajuste próprio de “Abrir Com”.** Solte uma pasta na caixa tracejada. O OpenWithPanel lista cada arquivo dela que tem o seu próprio ajuste de **Abrir Com**, com o app para o qual ele aponta. Selecione os arquivos e clique em **Remover os ajustes próprios**; eles passam a seguir o ajuste do seu tipo. A varredura ignora as pastas `.git`, `node_modules`, `.build`, `DerivedData`, `Pods`, `vendor`, `.venv` e `__pycache__`.

**Exportar um relatório de diagnóstico.** **Exportar relatório de diagnóstico…**, no fim da aba, salva um relatório de texto com a sua configuração, o app que abre atualmente cada tipo gerenciado pelo OpenWithPanel, o log desta sessão e o arquivo que você acabou de diagnosticar. Envie-o ao desenvolvedor ao relatar um problema.

## Ajustes

Abra **OpenWithPanel › Ajustes…** ou pressione `⌘,`.

**Geral**

- **Idioma:** escolha **Igual ao sistema** ou um dos 15 idiomas e clique em **Reabrir agora**. Se houver alterações não aplicadas, aplique-as ou descarte-as primeiro.
- **Modo de desenvolvedor:** mostra mais detalhes; veja [Modo de desenvolvedor](#modo-de-desenvolvedor). Ele só muda o que é exibido, nunca os seus ajustes.

**Regras de pasta**

Uma alternativa para quando o método usado para os arquivos sem extensão deixar de funcionar. Adicione uma pasta e escolha um app, e o OpenWithPanel dá a cada arquivo de texto sem extensão dessa pasta um ajuste próprio de **Abrir Com** para esse app.

- Arquivos binários, e arquivos que você mesmo definiu, não são alterados.
- Arquivos novos são tratados sempre que você abre o OpenWithPanel, ou na hora com **Aplicar agora**.
- **Desfazer todos os ajustes de pasta** devolve cada arquivo que o OpenWithPanel alterou ao estado anterior.
- **Ignorar pastas chamadas** é editável; por padrão, lista as pastas que a varredura de pastas do Diagnóstico ignora.

**Histórico**

Lista o instantâneo salvo antes de cada aplicação, até 20, do mais recente para o mais antigo. O último, **Inicial (antes de o OpenWithPanel alterar qualquer coisa)**, é o estado registrado na primeira vez que você abriu o OpenWithPanel. Qualquer um deles pode ser restaurado com **Restaurar…**, com uma prévia das diferenças antes.

**O que o OpenWithPanel gravou**

Lista cada lugar que o OpenWithPanel altera ou em que grava no seu Mac, cada um com **Mostrar no Finder**:

- **Associações de arquivo:** quantos itens (tipos de arquivo e links) o OpenWithPanel gerencia;
- **Entradas de preferências do LaunchServices:** as entradas que o OpenWithPanel gravou para os tipos de arquivo, incluindo os arquivos sem extensão;
- **OpenWithPanel Helper:** dentro do app OpenWithPanel;
- **Regras e instantâneos:** `~/Library/Application Support/net.zhaojian.openwithpanel/`;
- **Ajustes “Abrir Com” por arquivo:** só existem se você usou regras de pasta.

O OpenWithPanel não roda em segundo plano, não tem item de início de sessão, não faz conexões de rede e não coleta dados.

### Desinstalação

No fim de **O que o OpenWithPanel gravou**, clique em **Desinstalar o OpenWithPanel…** e escolha se quer apagar também as regras e os instantâneos. O OpenWithPanel então:

1. aponta cada tipo de arquivo e link que alterou de volta para o app original;
2. desfaz cada ajuste por arquivo feito pelas regras de pasta;
3. apaga ou mantém `~/Library/Application Support/net.zhaojian.openwithpanel/`, conforme a sua escolha;
4. move a si mesmo para o Lixo.

Se algum tipo de arquivo ou link não puder voltar a apontar para o app original — por exemplo, porque você recusou uma confirmação do sistema —, a desinstalação é interrompida e nada é removido.

Se você mantiver as regras e os instantâneos, ao reinstalar o OpenWithPanel aparece um aviso que restaura todos os seus ajustes com um clique. Ferramentas de limpeza que apagam os arquivos restantes de um app quando ele é movido para o Lixo também podem apagar as regras e os instantâneos que você escolheu manter; configure essa ferramenta para ignorar o OpenWithPanel.

Se, em vez disso, você mesmo arrastar o OpenWithPanel para o Lixo, o OpenWithPanel Helper vai junto e o macOS descarta as associações que apontavam para ele; os outros tipos continuam com os apps que o OpenWithPanel definiu. Um arquivo `UNINSTALL.txt` na pasta Application Support explica como restaurá-los nesse caso.

## Modo de desenvolvedor

Ative-o em **Ajustes › Geral**. Ele adiciona:

- o identificador de tipo do sistema (UTI) abaixo de cada formato, e um selo **Auxiliar** nos formatos encaminhados pelo OpenWithPanel Helper;
- a cadeia de decisão completa no diagnóstico: tipo, tipos pai, texto ou binário, a decisão, e como cada app capaz de abrir o arquivo o declara no seu Info.plist (extensão ou tipo correspondente, função e rank);
- uma aba **Regras** na janela principal;
- o tratamento de **Arquivos que não são texto** e as **Predefinições** nos ajustes.

As **Regras** decidem para onde o OpenWithPanel Helper envia os arquivos que recebe. Uma regra tem:

- condições, das quais pelo menos uma deve ser preenchida: um padrão de nome de arquivo (como `Dockerfile*`, sem diferenciar maiúsculas de minúsculas), uma pasta que contém o arquivo (como `~/Projects`) e se o conteúdo é texto ou binário;
- os tipos aos quais se aplica, `public.data` (arquivos sem extensão) por padrão; os outros tipos que você adicionar também são encaminhados pelo OpenWithPanel Helper;
- para onde enviar o arquivo: um app, **Mostrar no Finder** ou o **App original**.

As regras são verificadas de cima para baixo e a primeira que corresponder vence. Arraste para reordenar; o botão à esquerda desativa uma regra temporariamente. Os grupos afetados por regras mostram **Controlado por regras** no modo padrão.

**Arquivos que não são texto** define o que o OpenWithPanel Helper faz com arquivos binários: **Mostrar no Finder** (padrão), **Abrir com o mesmo app** ou **Abrir com o app original**.

**Predefinições** exporta os seus ajustes de grupo, ajustes por formato, extensões personalizadas e regras para um arquivo JSON que você pode importar em outro Mac; os ajustes importados entram em vigor depois que você clica em **Aplicar**. As regras de pasta e os registros de app original são específicos de cada Mac, então não são exportados nem sobrescritos na importação.

## Como funciona

O OpenWithPanel traz um minúsculo app auxiliar, o **OpenWithPanel Helper**, dentro do seu pacote de app. Quando você escolhe um editor para os arquivos sem extensão, o OpenWithPanel aponta `public.data` para o app auxiliar. Quando você abre um desses arquivos, o app auxiliar verifica as suas regras e o conteúdo do arquivo, entrega os arquivos de texto ao app escolhido, mostra os arquivos binários no Finder e encerra. Ele não fica em execução: o macOS só o inicia quando há um arquivo ou link para entregar, e ele encerra após menos de um segundo ocioso. Ele não tem janela e não aparece no Dock. Os links definidos como **Não abrir** também são enviados ao app auxiliar, que simplesmente os ignora.

Um arquivo é considerado binário se os seus primeiros 8 KB contiverem um byte nulo ou não forem UTF-8 válido.

Os tipos de arquivo que o app escolhido já suporta, como `.md` ou `.py`, são atribuídos diretamente a esse app, sem o app auxiliar.

O macOS não oferece uma API pública para definir um app padrão para `public.data`, e desde o macOS 26.4 a sua API pública pede confirmação para cada tipo de arquivo alterado. Por isso, o OpenWithPanel grava todas as alterações de tipos de arquivo de uma vez nas preferências do LaunchServices e reinicia o serviço `lsd` uma vez para que entrem em vigor. Esse mecanismo não é documentado pela Apple e pode parar de funcionar após uma atualização do sistema. Se uma alteração não entrar em vigor, o OpenWithPanel recorre à API pública, que pede a sua confirmação; para arquivos sem extensão, ele oferece as regras de pasta no lugar.

## Perguntas frequentes

**Como mudo o app padrão para arquivos sem extensão no Mac?**
Abra o OpenWithPanel, escolha um app para **Arquivos sem extensão** e pressione **Aplicar**. A partir daí, arquivos como `.env` e `Dockerfile` abrem nesse app.

**Por que o “Alterar Tudo” do Finder não funciona com arquivos `.env`?**
O macOS os trata como dados genéricos (`public.data`) e bloqueia a mudança do app padrão para esse tipo pelas suas APIs públicas. O OpenWithPanel contorna isso com o seu app auxiliar.

**Como faço do VS Code, do Zed ou do Sublime Text o editor padrão para arquivos de código?**
Escolha o editor para o grupo **Código**, ou para formatos individuais, e pressione **Aplicar**. Extensões sem um tipo oficial do macOS, como `.go` e `.rs`, também são cobertas.

**Posso desfazer tudo?**
Sim. O OpenWithPanel registra as associações originais na primeira vez que é executado e nunca sobrescreve esse registro. **Restaurar o estado inicial** aponta cada tipo alterado de volta para o app original.

**O OpenWithPanel coleta dados ou roda em segundo plano?**
Não. Ele não faz conexões de rede, não coleta dados, não instala agentes em segundo plano e não continua em execução depois que você o encerra. **Ajustes › O que o OpenWithPanel gravou** lista cada lugar em que ele grava.

**Por que o OpenWithPanel não usa sandbox?**
O macOS não permite que apps em sandbox alterem os apps padrão. Em vez disso, o OpenWithPanel usa o hardened runtime.

## Limitações conhecidas

- No macOS, `.ts` é reconhecido como um formato de vídeo (MPEG-2 transport stream), e alterá-lo afetaria arquivos de vídeo reais, então o grupo Código só cobre o `.tsx` do TypeScript. Da mesma forma, para o macOS `.r`, `.exs` e `.fs` são recursos Rez, arquivos de sampler do Logic e shaders, e não estão no grupo Código.
- Os ajustes de tipos de arquivo dependem de um mecanismo do sistema não documentado, que pode parar de funcionar após uma atualização do sistema. Se isso acontecer, os tipos de arquivo comuns recorrem automaticamente à API do sistema (uma confirmação por tipo), e os arquivos sem extensão podem usar as regras de pasta no lugar.
- O macOS só permite que um app leia o log do seu próprio processo, então o relatório de diagnóstico não inclui o log do OpenWithPanel Helper. Busque `net.zhaojian.openwithpanel` no app Console se precisar dele.
- As traduções da interface ainda não foram revisadas por falantes nativos.

## Compilar a partir do código-fonte

Requer Xcode 27.

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

Para gerar um DMG:

```sh
scripts/package.sh
```

O resultado vai para `.build/dist/`, junto com um cask do Homebrew gerado a partir de `packaging/openwithpanel.rb` com a versão e o checksum preenchidos. Sem variáveis de ambiente, o app é assinado ad hoc e não é notarizado; nesse caso, o DMG inclui `First Launch.txt`. Defina `DEVELOPER_ID` (o nome de um certificado Developer ID Application) para assinar com ele, e defina também `NOTARY_PROFILE` (um perfil de credenciais salvo com `xcrun notarytool store-credentials`) para notarizar e grampear o tíquete (staple).

As versões são compiladas pelo workflow do GitHub Actions em `.github/workflows/release.yml`. Como ele assina, e como publicar uma versão, está descrito em [docs/release.md](../release.md).

## Estrutura do projeto

- `OpenWithPanelKit/`: um pacote Swift local. `OpenWithPanelCore` contém toda a lógica; `OpenWithPanelPlatform` encapsula as APIs do sistema.
- `Apps/OpenWithPanel/`: o app principal (SwiftUI).
- `Apps/Helper/`: o app auxiliar embutido no pacote do app principal.
- `scripts/`, `packaging/`: o script de empacotamento e o modelo do cask do Homebrew.

## Licença

[MIT](../../LICENSE) © 2026 zhaoJian
