
sudo nerdctl run --rm -it \
  --device /dev/kfd \
  --device /dev/dri/renderD128 \
  --ipc host \
  --security-opt seccomp=unconfined \
  --ulimit memlock=-1:-1 \
  --mount type=bind,src="$PWD",dst=/workspace \
  --workdir /workspace \
  docker.io/rocm/dev-ubuntu-24.04:7.2.1-complete \
  bash
