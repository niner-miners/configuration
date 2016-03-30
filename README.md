# Niner Miners Core

The nuts and bolts of the UNC Charlotte Official Minecraft server.

## Dependencies

- [dropbox](https://www.dropbox.com/install)
- [git](https://git-scm.com/)
- [java](https://java.com/en/download/)
- [ssh](http://www.openssh.com/)

## Directory Layout

```
$HOME/
├── api/
│   └── # a Node server running an API
├── core/
│   └── # this repository
└── minecraft/
    ├── spigot.jar
    └── # all other Minecraft server files
```

## Ports

**8122** ‒ API

**8123** ‒ Dynamp

**25565** ‒ Minecraft

## Running

Setup "fake" home directory:

**NOTE:** `fake-home/` can be what ever path you like.
```
mkdir $HOME/fake-home/
cd $HOME/fake-home/
```
Clone this repository:
```
git clone THIS_REPOSITORY core/
```
Quick setup of Minecraft files:
```
mkdir minecraft/
wget --output-document=minecraft/spigot.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.9/minecraft_server.1.9.jar
echo "eula=true" > minecraft/eula.txt
```
Start the Minecraft server:
```
HOME=$HOME/fake-home/ ./core/actions/server
```
