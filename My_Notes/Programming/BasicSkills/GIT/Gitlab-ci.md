# Gitlab-ci

tags: #git #gitlab #cicd #hooks

主要想記錄gitlab自動化測試以及gitlab-ci.yaml的撰寫方式

github 也有類似的功能[[Github actions]]

中文參考 

https://nick-chen.medium.com/%E6%95%99%E5%AD%B8-gitlab-ci-%E5%85%A5%E9%96%80%E5%AF%A6%E4%BD%9C-%E8%87%AA%E5%8B%95%E5%8C%96%E9%83%A8%E7%BD%B2%E7%AF%87-ci-cd-%E7%B3%BB%E5%88%97%E5%88%86%E4%BA%AB%E6%96%87-cbb5100a73d4

https://ithelp.ithome.com.tw/articles/10219427



## 應用: 建立Tag時自動編譯執行檔並release

正好手邊有這樣的需求，搞定之後趕緊記下來。

主要是參考[這篇文章](https://gitlab.kenda.com.tw/help/user/project/releases/index#release-assets)



範例的yaml如下

```yaml
stages:
  - build
  - upload
  - release

variables:
  # Package version can only contain numbers (0-9), and dots (.).
  # Must be in the format of X.Y.Z, i.e. should match /\A\d+\.\d+\.\d+\z/ regular expresion.
  # See https://docs.gitlab.com/ee/user/packages/generic_packages/#publish-a-package-file
  PACKAGE_VERSION: "1.2.3"
  DARWIN_AMD64_BINARY: "myawesomerelease-darwin-amd64-${PACKAGE_VERSION}"
  LINUX_AMD64_BINARY: "myawesomerelease-linux-amd64-${PACKAGE_VERSION}"
  PACKAGE_REGISTRY_URL: "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/myawesomerelease/${PACKAGE_VERSION}"

build:
  stage: build
  image: alpine:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - mkdir bin
    - echo "Mock binary for ${DARWIN_AMD64_BINARY}" > bin/${DARWIN_AMD64_BINARY}
    - echo "Mock binary for ${LINUX_AMD64_BINARY}" > bin/${LINUX_AMD64_BINARY}
  artifacts:
    paths:
      - bin/

upload:
  stage: upload
  image: curlimages/curl:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${DARWIN_AMD64_BINARY} "${PACKAGE_REGISTRY_URL}/${DARWIN_AMD64_BINARY}"
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${LINUX_AMD64_BINARY} "${PACKAGE_REGISTRY_URL}/${LINUX_AMD64_BINARY}"

release:
  # Caution, as of 2021-02-02 these assets links require a login, see:
  # https://gitlab.com/gitlab-org/gitlab/-/issues/299384
  stage: release
  image: registry.gitlab.com/gitlab-org/release-cli:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      release-cli create --name "Release $CI_COMMIT_TAG" --tag-name $CI_COMMIT_TAG \
        --assets-link "{\"name\":\"${DARWIN_AMD64_BINARY}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${DARWIN_AMD64_BINARY}\"}" \
        --assets-link "{\"name\":\"${LINUX_AMD64_BINARY}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${LINUX_AMD64_BINARY}\"}"

```



把它改成我自己需要的golang版本，最後成品如下

```yaml
image: golang:1.18.2-alpine3.16

stages:
  - build
  - upload
  - release

variables:
  PACKAGE_NAME: "ReleaseBinaryFile"
  PACKAGE_VERSION: "0.0.1"
  DARWIN_AMD64_BINARY: "hello.exe"
  PACKAGE_REGISTRY_URL: "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/${PACKAGE_NAME}/${PACKAGE_VERSION}"

build:
  stage: build
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - mkdir bin
    - go build -o bin/${DARWIN_AMD64_BINARY} .
  artifacts:
    paths:
      - bin/


upload:
  stage: upload
  image: curlimages/curl:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${DARWIN_AMD64_BINARY} "${PACKAGE_REGISTRY_URL}/${DARWIN_AMD64_BINARY}"
    - echo "${PACKAGE_REGISTRY_URL}/${DARWIN_AMD64_BINARY}"

release:
  stage: release
  image: registry.gitlab.com/gitlab-org/release-cli:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      release-cli create --name "Release $CI_COMMIT_TAG" --tag-name $CI_COMMIT_TAG \
        --assets-link "{\"name\":\"${DARWIN_AMD64_BINARY}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${DARWIN_AMD64_BINARY}\"}" 

```

PS 這個寫法搭配linux環境的 ci runner 編譯出來的是linux的執行檔

如果有windows runner或打算設置windows runner的話可以參考[這篇文章](https://editor.leonh.space/2021/gitlab-ci/)，比較需要注意的是windows系統並非docker container所以不能設定image

不想用windows runner的話，就改成在linux系統編譯windows執行檔。



重點整理下:

1. `PACKAGE_REGISTRY_URL`:就是Post上傳檔案的url，他是有限制格式的，不照格式走也會put成功，但是會找不到檔案。

   ```http
   PUT /projects/:id/packages/generic/:package_name/:package_version/:file_name?status=:status
   ```

   [這篇文章](https://docs.gitlab.com/ee/user/packages/generic_packages/#publish-a-package-file)裡面有詳細說明，比較要特別注意的是package name 和 version，他們有regular expression的檢查。

2. `artifacts`用於保留這個job的改動，讓他到之後的job可以接續使用，比如這邊的情況就是bin資料夾及其內容物會在`build` job生成，在`upload` job被使用，如果沒有將其保留在`artifacts`就會造成 `upload` job 找不到目標的情形。

   當然如果把他們寫在同一個job就可以不用定`artifacts`了。



---

最終版本

build.sh

```bash
#!/usr/bin/env bash

target=$1
output_file_prefix=$2
if [[ -z "$target" ]]; then
  echo "usage: $0 <target> <output_file_prefix>"
  echo "example: $0 . test/test"
  exit 1
fi

platforms=("windows/amd64" "linux/amd64")
# platforms=("windows/amd64" "windows/arm64" "windows/386" "darwin/amd64" "linux/amd64")

for platform in "${platforms[@]}"
do
	read -r -a <<< "${platform//\// }" platform_split
	GOOS=${platform_split[0]}
	GOARCH=${platform_split[1]}
	output_name=$output_file_prefix'-'$GOOS'-'$GOARCH
	if [ "$GOOS" = "windows" ]; then
		output_name+='.exe'
	fi

	if ! env GOOS="$GOOS" GOARCH="$GOARCH" go build -o $output_name "$target"; then
   		echo 'An error has occurred! Aborting the script execution...'
		exit 1
	fi
done
```

.gitlab-ci.yml

```yaml
image: golang:1.18.2

stages:
  - build
  - upload
  - release

variables:
  PACKAGE_NAME: "ReleaseBinaryFile"
  PACKAGE_VERSION: "0.0.1"
  FILE_NAME: "hello"
  WIN_AMD64_FILE_NAME: "${FILE_NAME}-windows-amd64.exe"
  WIN_ARM64_FILE_NAME: "${FILE_NAME}-windows-arm64.exe"
  WIN_386_FILE_NAME: "${FILE_NAME}-windows-386.exe"
  LINUX_AMD64_FILE_NAME: "${FILE_NAME}-linux-amd64"
  DARWIN_AMD64_FILE_NAME: "${FILE_NAME}-darwin-amd64"
  PACKAGE_REGISTRY_URL: "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/${PACKAGE_NAME}/${PACKAGE_VERSION}"

build:
  stage: build
  # image: ubuntu:22.10
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - mkdir bin
    - chmod 777 ./build.sh
    - ./build.sh . bin/${FILE_NAME}
  artifacts:
    paths:
      - bin/


upload:
  stage: upload
  image: curlimages/curl:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${WIN_AMD64_FILE_NAME} "${PACKAGE_REGISTRY_URL}/${WIN_AMD64_FILE_NAME}"
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${WIN_ARM64_FILE_NAME} "${PACKAGE_REGISTRY_URL}/${WIN_ARM64_FILE_NAME}"
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${WIN_386_FILE_NAME} "${PACKAGE_REGISTRY_URL}/${WIN_386_FILE_NAME}"
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${LINUX_AMD64_FILE_NAME} "${PACKAGE_REGISTRY_URL}/${LINUX_AMD64_FILE_NAME}"
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${DARWIN_AMD64_FILE_NAME} "${PACKAGE_REGISTRY_URL}/${DARWIN_AMD64_FILE_NAME}"
      
release:
  stage: release
  image: registry.gitlab.com/gitlab-org/release-cli:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      release-cli create --name "Release $CI_COMMIT_TAG" --tag-name $CI_COMMIT_TAG \
        --assets-link "{\"name\":\"${WIN_AMD64_FILE_NAME}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${WIN_AMD64_FILE_NAME}\"}" \
        --assets-link "{\"name\":\"${WIN_ARM64_FILE_NAME}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${WIN_ARM64_FILE_NAME}\"}" \
        --assets-link "{\"name\":\"${WIN_386_FILE_NAME}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${WIN_386_FILE_NAME}\"}" \
        --assets-link "{\"name\":\"${LINUX_AMD64_FILE_NAME}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${LINUX_AMD64_FILE_NAME}\"}" \
        --assets-link "{\"name\":\"${DARWIN_AMD64_FILE_NAME}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${DARWIN_AMD64_FILE_NAME}\"}" 

```

原本的golang image (alpine 3.16)不支援bash，所以改了一下。

如果我在stage階段使用image，原本的image就會失效，總之就是一次只能用一種。



如果還是要用alpine版本的話就要另外安裝bash工具，如下

```yaml
image: golang:1.18.2-alpine3.16

stages:
  - test
  - build
  - upload
  - release

variables:
  SSH_PRIVATE_KEY: ${SSH_PRIVATE_KEY}
  PACKAGE_NAME: "kgoimports"
  FILE_NAME: "kgoimports"
  WIN_AMD64_FILE_NAME: "${FILE_NAME}-windows-amd64.exe"
  WIN_ARM64_FILE_NAME: "${FILE_NAME}-windows-arm64.exe"
  WIN_386_FILE_NAME: "${FILE_NAME}-windows-386.exe"
  LINUX_AMD64_FILE_NAME: "${FILE_NAME}-linux-amd64"
  DARWIN_AMD64_FILE_NAME: "${FILE_NAME}-darwin-amd64"
  PACKAGE_REGISTRY_URL: "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/${PACKAGE_NAME}/${CI_COMMIT_TAG}"

test:
  stage: test
  script:
    - apk add build-base
    - go mod download
    - go vet ./...


build:
  stage: build
  # image: ubuntu:22.10
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - apk update
    - apk upgrade
    - apk add bash
    - mkdir bin
    - chmod 777 ./build.sh
    - ./build.sh . bin/${FILE_NAME}
  artifacts:
    paths:
      - bin/


upload:
  stage: upload
  image: curlimages/curl:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${WIN_AMD64_FILE_NAME} "${PACKAGE_REGISTRY_URL}/${WIN_AMD64_FILE_NAME}"
    - |
      curl --header "JOB-TOKEN: ${CI_JOB_TOKEN}" --upload-file bin/${LINUX_AMD64_FILE_NAME} "${PACKAGE_REGISTRY_URL}/${LINUX_AMD64_FILE_NAME}"

release:
  stage: release
  image: registry.gitlab.com/gitlab-org/release-cli:latest
  rules:
    - if: $CI_COMMIT_TAG
  script:
    - |
      release-cli create --name "Release $CI_COMMIT_TAG" --tag-name $CI_COMMIT_TAG \
        --assets-link "{\"name\":\"${WIN_AMD64_FILE_NAME}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${WIN_AMD64_FILE_NAME}\"}" \
        --assets-link "{\"name\":\"${LINUX_AMD64_FILE_NAME}\",\"url\":\"${PACKAGE_REGISTRY_URL}/${LINUX_AMD64_FILE_NAME}\"}"
```

(這個版本我有減少建置的執行檔種類，不過這不是重點)
