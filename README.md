# Dockerized MageSuite MagePack advanced JS asset bundler for Magento

[![](https://images.microbadger.com/badges/image/magesuite/bundle-theme-js:stable.svg)](https://microbadger.com/images/magesuite/bundle-theme-js:stable "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/magesuite/bundle-theme-js:stable.svg)](https://microbadger.com/images/magesuite/bundle-theme-js:stable "Get your own version badge on microbadger.com")

Please first make yourself familiar with [magepack](https://github.com/magesuite/magepack) as this is only
a dockerized execution environment to make your build system clean of unnecessary dependencies.

**Caution!** Avoid using the docker `:latest` tag as it might be unusable, use `:stable` instead as it's built
from the stable tagged versions.

## Prerequisites

- Make sure that your magepack configuration is present in the project's root directory in file named exactly `build.js`.
- Before running this command your Magento static assets should already be deployed and present in the subdirectory
  `pub/static/frontend/{name-of-your-theme-vendor}`.
  
## Usage

Go to the root directory of your Magento project and execute:

```bash
docker run -v ${PWD}:/workdir  -u $(id -u `whoami`):$(id -g `whoami`) magesuite/bundle-theme-js:stable "{name-of-your-theme-vendor}"
```  


