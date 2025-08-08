# Use a imagem oficial do Ruby como base
FROM ruby:3.3.0-slim

# Instalar dependências do sistema
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/*

# Definir o diretório de trabalho no container
WORKDIR /app

# Copiar os arquivos Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar as gems
RUN bundle install

# Copiar o restante do código da aplicação para o container
COPY . .

# Expor a porta 3000 para o servidor Rails
EXPOSE 3000

# O comando para iniciar a aplicação
CMD ["rails", "server", "-b", "0.0.0.0"]
