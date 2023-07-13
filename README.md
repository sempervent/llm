# llm
Run an LLM locally.

This uses the wonderful dalai to populate the models and to serve them 
optionally. <TODO add in a link to dalai github>.

# running
```bash
docker compose build
docker compose run dalai npx dalai alpaca install 7B 13B
```

You can access at [http://127.0.0.1:3000/](http://127.0.0.1:3000/)