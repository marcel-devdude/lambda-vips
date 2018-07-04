Build & start container:

```
docker build -t lambda-vips .
docker run -it lambda-vips bash
```


Inside container:

```
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${TARGET}/lib/pkgconfig"
npm install sharp

LD_LIBRARY_PATH=${TARGET}/lib node index.js
```
