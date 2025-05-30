```
docker run -i --rm -e DATABASE_URI="postgresql://postgres:postgres@host.docker.internal:5432/postgres" crystaldba/postgres-mcp --access-mode=unrestricted
```

```
docker run -i -d --name postgres-mcp-server -e DATABASE_URI="postgresql://postgres:postgres@localhost:5432/postgres" crystaldba/postgres-mcp --access-mode=unrestricted
```

```
docker run -i -d --rm  -e DATABASE_URI="postgresql://postgres:postgres@localhost:5432/postgres" crystaldba/postgres-mcp --access-mode=unrestricted
```

```
postgres-mcp --access-mode=unrestricted "postgresql://postgres:postgres@localhost:5432/postgres"
```

```
postgres-mcp --access-mode=unrestricted --transport=sse --sse-host 0.0.0.0 --sse-port 8000 "postgresql://postgres:postgres@localhost:5432/postgres"
```
