# Cross Compile

tags: #golang #compile/cross_compile

## Goos table

| `GOOS` - Target Operating System | `GOARCH` - Target Platform |
| :------------------------------: | :------------------------: |
|            `android`             |           `arm`            |
|             `darwin`             |           `386`            |
|             `darwin`             |          `amd64`           |
|             `darwin`             |           `arm`            |
|             `darwin`             |          `arm64`           |
|           `dragonfly`            |          `amd64`           |
|            `freebsd`             |           `386`            |
|            `freebsd`             |          `amd64`           |
|            `freebsd`             |           `arm`            |
|             `linux`              |           `386`            |
|             `linux`              |          `amd64`           |
|             `linux`              |           `arm`            |
|             `linux`              |          `arm64`           |
|             `linux`              |          `ppc64`           |
|             `linux`              |         `ppc64le`          |
|             `linux`              |           `mips`           |
|             `linux`              |          `mipsle`          |
|             `linux`              |          `mips64`          |
|             `linux`              |         `mips64le`         |
|             `netbsd`             |           `386`            |
|             `netbsd`             |          `amd64`           |
|             `netbsd`             |           `arm`            |
|            `openbsd`             |           `386`            |
|            `openbsd`             |          `amd64`           |
|            `openbsd`             |           `arm`            |
|             `plan9`              |           `386`            |
|             `plan9`              |          `amd64`           |
|            `solaris`             |          `amd64`           |
|            `windows`             |           `386`            |
|            `windows`             |          `amd64`           |

## windows ➡ linux

build linux exe from windows <https://stackoverflow.com/questions/49449190/golang-on-windows-how-to-build-for-linux>

另外有一篇比較老的，實際使用沒有成功

```shell
env GOOS=linux go build -o filename
```

記得用bash跑，powershell會失敗

## bash script

參考[這篇文章](https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-16-04)改的

```bash
#!/usr/bin/env bash

package=$1
package_name=$2
if [[ -z "$package" ]]; then
  echo "usage: $0 <package-name>"
  exit 1
fi
package_split=(${package//\// })
# package_name=${package_split[-1]}
	
platforms=("windows/amd64" "windows/386" "darwin/amd64")

for platform in "${platforms[@]}"
do
	platform_split=(${platform//\// })
	GOOS=${platform_split[0]}
	GOARCH=${platform_split[1]}
	output_name=$package_name'-'$GOOS'-'$GOARCH
	if [ $GOOS = "windows" ]; then
		output_name+='.exe'
	fi	

	env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name $package
	if [ $? -ne 0 ]; then
   		echo 'An error has occurred! Aborting the script execution...'
		exit 1
	fi
done
```
