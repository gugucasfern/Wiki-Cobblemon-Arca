# Wiki Arca

Site estático para consulta local e publicação no GitHub Pages.

- `index.html` é a página inicial.
- `guias/*.md` são as fontes editáveis dos guias.
- `guias/*.html` são as páginas exibidas pelo site estático.
- `build-guides.ps1` atualiza os HTML dos guias a partir dos Markdown.
- `assets/style.css` contém o tema responsivo.

Ao editar um Markdown de guia, execute `./build-guides.ps1` no PowerShell a partir desta pasta para sincronizar a página HTML. Para ver localmente, abra `index.html` no navegador. O site usa caminhos relativos e pode ser publicado como raiz de um projeto no GitHub Pages.
