# SkinRestorer

O SkinRestorer permite buscar e aplicar skins usando o nome de usuário de serviços compatíveis ou o endereço de uma imagem. A seleção fica vinculada ao seu jogador no servidor; não é necessário instalar nada além do pack normal.

## Usando uma skin do Ely.by

1. Crie uma conta em [Ely.by](https://ely.by/) e entre no site.
2. Escolha uma skin no catálogo e aplique-a à sua conta Ely.by.
3. Entre no servidor e, no chat, use o comando abaixo, trocando o exemplo pelo seu nome de usuário no Ely.by:

   ```text
   /skin set ely.by SeuNomeNoElyBy
   ```

O mod procura a skin associada àquela conta e a aplica ao seu personagem. Jogadores com conta oficial não precisam fazer nada para manter a própria skin; quem usa uma conta sem skin oficial pode usar esse método.

## Usando uma imagem da web

O SkinRestorer aceita uma URL de imagem e envia a skin para processamento. O endereço deve apontar diretamente para o arquivo da imagem, não para uma página de galeria, visualizador ou página de perfil.

1. Encontre uma skin e copie o link direto do arquivo de imagem. A imagem precisa seguir o formato de skin do Minecraft (normalmente PNG, 64 × 64 pixels).
2. Decida o modelo do personagem: `classic` para o modelo Steve, com braços mais largos, ou `slim` para o modelo Alex, com braços mais estreitos.
3. No chat do servidor, use o comando e substitua a URL pelo link direto:

   ```text
   /skin set web classic "https://exemplo.com/minha-skin.png"
   ```

   Para o modelo Alex, troque `classic` por `slim`:

   ```text
   /skin set web slim "https://exemplo.com/minha-skin.png"
   ```

Use aspas em torno da URL, especialmente quando ela contiver `?`, `&` ou outros caracteres. Um link que abre uma página HTML não serve: o servidor precisa conseguir baixar diretamente a imagem da skin. O recurso usa um serviço externo de processamento de skins; por isso, a URL precisa estar acessível pela internet.

## Atualizar ou remover

- `/skin refresh` tenta atualizar a skin vinculada, por exemplo depois de você alterar a skin na conta de origem.
- Para trocar por outra imagem ou usuário, execute novamente o comando `/skin set` correspondente.
- Os comandos e permissões podem depender da configuração do servidor. Se aparecer mensagem de falta de permissão ou falha no carregamento, procure a equipe.

> A forma do comando de URL segue a documentação do [SkinRestorer](https://github.com/Suiranoil/SkinRestorer/wiki/Commands). A disponibilidade no servidor depende da versão instalada e das permissões configuradas.
