```bash
//install gitbook
$ npm install gitbook-cli -g
$ gitbook --version
CLI version: 2.3.2
GitBook version: 3.2.3

//build only
$ gitbook build

//generate summary
$ npm install -g gitbook-summary
$ rm -rf SUMMARY.md _book
$ book sm -i node_modules,_book,BUILD

$ npm i gitbook-plugin-collapsible-menu
$ npm i gitbook-plugin-toc

//build and preview
$ gitbook serve
...
Starting server ...
Serving book on http://localhost:4000
```
