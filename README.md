Docker container for running [Folding@Home](http://folding.stanford.edu/)

### Usage
```bash
docker build -t folding-at-home .

docker run --rm -it -p7396:7396 folding-at-home:latest \
    --user=nanashi --team=162 --gpu=true --smp=true --power=full
```

The web console is available on port `7396`.
