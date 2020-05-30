![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/akito13/murmur?style=plastic)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/akito13/murmur?style=plastic)

![Docker Stars](https://img.shields.io/docker/stars/akito13/murmur?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/akito13/murmur?style=plastic)

![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/akito13/murmur?style=plastic)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/akito13/murmur?style=plastic)

[![Upstream](https://img.shields.io/badge/upstream-project-yellow?style=plastic)](https://github.com/mumble-voip/mumble.git)

![GitHub](https://img.shields.io/badge/license-GPL--3.0-informational?style=plastic)
![Liberapay patrons](https://img.shields.io/liberapay/patrons/Akito?style=plastic)

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


## License
Copyright (C) 2020  Akito <the@akito.ooo>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
