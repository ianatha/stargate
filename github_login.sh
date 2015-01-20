#!/bin/bash -e
CLIENT_ID=$GITHUB_OAUTH_CLIENT_ID
CLIENT_SECRET=$GITHUB_OAUTH_CLIENT_SECRET
SCOPE="user:email"
PRE_CODE=`/Users/thatha/Library/Developer/Xcode/DerivedData/stargate-fffbksnydnnqvpaflofyywoejdxh/Build/Products/Debug/stargate "https://github.com/login/oauth/authorize?client_id=$CLIENT_ID&redirect_uri=stargate-result://result&scope=$SCOPE"`
CODE=`echo $PRE_CODE | sed s#stargate-result://result?code=##`
AUTH_JSON=`curl -s -H 'Accept: application/json' --data "code=$CODE&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET" https://github.com/login/oauth/access_token`
AUTH_TOKEN=`echo $AUTH_JSON | jsawk 'return this.access_token'`
USER_INFO=`curl -s -H "Authorization: token $AUTH_TOKEN" https://api.github.com/user`

USERNAME=`echo $USER_INFO | jsawk 'return this.login'`
HUMANNAME=`echo $USER_INFO | jsawk 'return this.name'`

echo $USERNAME
echo $HUMANNAME
