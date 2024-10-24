FROM node:lts-alpine

# Definir variáveis de ambiente
ENV NODE_ENV=production

# Definir o diretório de trabalho no container
WORKDIR /usr/src/app

# Copiar arquivos de configuração de dependências
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]

# Instalar CLI do NestJS globalmente
RUN npm install -g @nestjs/cli

# Instalar dependências de produção silenciosamente
RUN npm install --production --silent && mv node_modules ../

# Copiar o código da aplicação
COPY . .

# Instalar tipagens e dependências de desenvolvimento (somente no modo desenvolvimento)
RUN if [ "$NODE_ENV" != "production" ]; then npm install --save-dev @types/node; fi

# Expor a porta 3000
EXPOSE 3000

# Mudar a permissão de usuário para node
RUN chown -R node /usr/src/app

# Definir o usuário como node para segurança
USER node

# Comando para iniciar a aplicação
CMD ["npm", "start"]
