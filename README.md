# Heroku Buildpack to notify NewRelic when deploying

When NewRelic is not taken from an Heroku addon.

## Install

    heorku config:set NEW_RELIC_API_KEY=... NEW_RELIC_APP_ID=...
    heroku buildpacks:add https://github.com/aq/heroku-buildpack-newrelic-deploy-notification.git
    git push
