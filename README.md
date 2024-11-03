# AUTOMATIC1111 Docker Builder

docker build --progress=plain -t automatic .

docker run --gpus=all -it -v./models:/models -v./cache:/home/automatic/.cache --entrypoint bash -p7860:7860 automatic
