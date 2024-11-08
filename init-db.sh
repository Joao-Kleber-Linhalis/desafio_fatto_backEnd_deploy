#!/bin/bash
# Inicia o PostgreSQL
pg_ctlcluster 13 main start
# Cria o banco de dados se não existir
psql -U postgres -c "CREATE DATABASE desafio_fatto_db;"