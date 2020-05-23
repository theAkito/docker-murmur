## Description

This is a repository providing a Docker image featuring [murmur](https://github.com/mumble-voip/mumble).

## Usage

1. Check `docker-compose.yaml` and adjust for example the mountpoint location of the `/data` volume to your system.
2. Tweak `murmur.ini` to your needs.
3. Copy `murmur.ini` to the location set as a mountpoint in the `docker-compose.yaml`. Default is: `/home/murmur/data`

Then, run the deployment with `docker-compose`:
```bash
docker-compose up -d
```

## Getting the super-user password

On first run, if you don't already have an existing state database, you'll want to look at the logs for your container to get the super-user password: 

```bash
$ docker logs -f murmur 2>&1 | grep Password
<W>2014-07-27 01:41:31.256 1 => Password for 'SuperUser' set to '(mAq3hkwnkD'
```
