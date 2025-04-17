homebrew 安装无响应的解决办法：
export HOMEBREW_NO_INSTALL_FROM_API=1
这样就禁止brew通过API安装，在国内似乎API连接不上

---

Raindrop build error:
```
ERROR in Sentry CLI Plugin: Command failed: /Users/tcai/Projects/Atmaware/Ruminer/raindrop/node_modules/@sentry/cli/sentry-cli releases new 1744451826272
error: API request failed
  caused by: sentry reported an error: Authentication credentials were not provided. (http status: 401)
```

Fix:
yarn build --env sentry.disabled=true

---

Symlink `.env` in the root directory of `karakeep` from each app directory:
`ln -s ../../.env apps/web/.env && ln -s ../../.env apps/workers/.env && ln -s ../../.env packages/db/.env`

---

Resize GCP disk:
```
gcloud compute disks resize ruminer-test-vm --size=60GB --zone=us-central1-a
gcloud compute ssh ruminer-test-vm --zone=us-central1-a
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1
sudo fdisk -l /dev/sda
```

---

Difference between `docker-compose.yml` and `self-hosting/docker-compose/docker-compose.yml`:
The former is for local development, while the latter is for production.
