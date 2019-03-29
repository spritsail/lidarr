[hub]: https://hub.docker.com/r/spritsail/lidarr
[git]: https://github.com/spritsail/lidarr
[drone]: https://drone.spritsail.io/spritsail/lidarr
[mbdg]: https://microbadger.com/images/spritsail/lidarr

# [Spritsail/Lidarr][hub]

[![Layers](https://images.microbadger.com/badges/image/spritsail/lidarr.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/spritsail/lidarr.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/spritsail/lidarr.svg)][git]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/lidarr.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/lidarr.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/lidarr/status.svg)][drone]


[Lidarr](https://github.com/Lidarr/Lidarr) running in Alpine Linux. This container provides some simple initial configuration scripts to set some runtime variables (see [#Configuration](#configuration) for details)

## Usage

Basic usage with default configuration:
```bash
docker run -dt
    --name=lidarr
    --restart=always
    -v $PWD/config:/config
    -p 8686:8686
    spritsail/lidarr
```

**Note:** _Is is important to use `-t` (pseudo-tty) as without it there are no logs produced._

Advanced usage with custom configuration:
```bash
docker run -dt
    --name=lidarr
    --restart=always
    -v $PWD/config:/config
    -p 8686:8686
    -e URL_BASE=/lidarr
    -e ANALYTICS=false
    -e ...
    spritsail/lidarr
```

### Volumes

* `/config` - Lidarr configuration file and database storage. Should be readable and writeable by `$SUID`

Other files accessed by Lidarr such as tv-show directories should also be readable and writeable by `$SUID` or `$SGID` with sufficient permissions.

`$SUID` defaults to 923

### Configuration

These configuration options set the respective options in `config.xml` and are provided as a Docker convenience.

* `LOG_LEVEL` - Options are:  `Trace`, `Debug`, `Info`. Default is `Info`
* `URL_BASE`  - Configurable by the user. Default is _empty_
* `BRANCH`    - Upstream tracking branch for updates. Options are: `master`, `develop`, _other_. Default is `develop`
* `ANALYTICS` - Truthy or falsy value `true`, `false` or similar. Default is `true`
