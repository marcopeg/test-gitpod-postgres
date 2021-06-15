FROM hasura/graphql-engine:v2.0.0-beta.1 as hasura
FROM gitpod/workspace-postgres

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  && apt-get install -y \
    unixodbc-dev \
    unixodbc \


###
### HASURA ENGINE
###

COPY --from=hasura /bin/graphql-engine /bin/graphql-engine

# Creates the `hasura_start` command:
ENV PATH="$PATH:$HOME/.hasura/bin"
RUN mkdir -p /home/gitpod/.hasura/bin \
  && printf "#!/bin/bash\n/bin/graphql-engine serve" > /home/gitpod/.hasura/bin/hasura_start \
  && chmod +x /home/gitpod/.hasura/bin/*

RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

# Ensure the basic environment variables that are needed by Hasura to start
ENV HASURA_GRAPHQL_DATABASE_URL="postgres://localhost:5432/postgres"
ENV HASURA_GRAPHQL_ENABLE_CONSOLE="true"
