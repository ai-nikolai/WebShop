# Docker should be fully working now.

## Running Docker from DockerHub:
```bash
docker container run -p 3000:3000 ainikolai/webshop:latest
```

(Make sure to test it by opening the browser on [localhost:3000]).

## Building Docker locally:
```bash
docker image build -t ainikolai/webshop:v2 .
```

Running the image:
```bash
docker container run -p 3000:3000 ainikolai/webshop:v2
```

Pushing image:
```bash
docker image push ainikolai/webshop:latest
```

## For interactive running of the docker container:
```bash
docker container run -it ainikolai/webshop:v2 bash
```
