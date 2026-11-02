# Fluxo — gestão de caixa

Aplicação React responsiva com autenticação e banco PostgreSQL hospedado no Supabase. Projetada para deploy no Vercel.

## Rodar localmente

1. Instale Node.js 20 ou superior.
2. No terminal do VS Code, entre nesta pasta e rode `npm install`.
3. Crie um projeto em [Supabase](https://supabase.com/).
4. No painel Supabase, abra **SQL Editor**, cole e execute `supabase/schema.sql`.
5. Copie `.env.example` para `.env.local` e preencha `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY` em **Project Settings → API**.
6. Rode `npm run dev` e abra o endereço local exibido pelo Vite.

Sem as variáveis do Supabase, o site abre em modo de demonstração com dados fictícios. Nesse modo os dados não são persistidos. Com o Supabase configurado, crie uma conta, confirme o e-mail se o projeto exigir e cadastre uma empresa em **Configurações**; os lançamentos serão salvos no banco.

## Hospedar no Vercel

1. Envie a pasta do projeto a um repositório Git.
2. Importe o repositório no Vercel. Ele detecta o Vite automaticamente; comando de build `npm run build`, pasta de saída `dist`.
3. Nas configurações do projeto Vercel, adicione `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY` com os valores do seu projeto Supabase.
4. Publique/republique o projeto. Em Supabase **Authentication → URL Configuration**, inclua o domínio publicado nas URLs permitidas.

## Segurança e limites

- `schema.sql` habilita Row Level Security (RLS) para que cada usuário acesse apenas as empresas que possui e os respectivos dados.
- Use somente a chave pública `anon` no navegador. Nunca coloque `service_role` ou segredos no código frontend.
- O banco e o frontend ficam em serviços separados: Vercel hospeda a aplicação; Supabase hospeda autenticação e PostgreSQL.
- Categorias, contas e contatos têm tabelas preparadas no banco; seus formulários de administração e importação CSV ainda são uma próxima etapa.
- Antes de produção, configure domínio, política de recuperação de senha, confirmação de e-mail e cópias de segurança no Supabase.

