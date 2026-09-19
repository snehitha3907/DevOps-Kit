# last_verified: 2026-09-19 · Containerization Concepts Docker SDK 29.2.0
import docker
import sys


def inspect_image(image_name):
    """Pull an image and report its layers and metadata."""
    client = docker.from_env()
    try:
        image = client.images.get(image_name)
    except docker.errors.ImageNotFound:
        print(f"Pulling {image_name}...")
        image = client.images.pull(image_name)
    print(f"Image: {image_name}")
    print(f"ID: {image.id}")
    print(f"Created: {image.attrs.get('Created', 'unknown')}")
    print(f"Size: {image.attrs.get('Size', 0) / (1024**2):.1f} MB")
    print(f"OS: {image.attrs.get('Os', 'unknown')}")
    print("Layers:")
    for layer in image.attrs.get("RootFS", {}).get("Layers", []):
        print(f"  {layer}")
    history = client.api.history(image_name)
    print("History:")
    for entry in history:
        print(f"  {entry.get('CreatedBy', 'unknown')}: {entry.get('Size', 0)} bytes")
    return image.attrs


if __name__ == "__main__":
    name = sys.argv[1] if len(sys.argv) > 1 else "alpine:latest"
    inspect_image(name)
