#! /usr/bin/bash

git clone git@github.com:MicrosoftCSA/react-component-toolkit.git 

Set-Location ./react-component-toolkit

git checkout dev

node install.mjs

npm run ladle:dev
