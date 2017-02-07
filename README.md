# Heroku Buildpack to notify NewRelic when deploying

When NewRelic is not taken from an Heroku addon.

## Install

    # Use heroku-buildpack-multi
    $ cd /path/to/your-app
    $ heroku config:add BUILDPACK_URL=https://github.com/s12chung/heroku-buildpack-multi.git

    # Create a .buildpacks file which includs this buildpack
    $ cd /path/to/your-app
    $ cat .buildpacks
    https://github.com/heroku/heroku-buildpack-ruby.git
    https://github.com/aq/heroku-buildpack-newrelic-deploy-notification.git

    # Push changes to deploy
    $ git push
