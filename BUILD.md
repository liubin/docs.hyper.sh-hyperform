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

//build and preview
$ gitbook serve
...
Starting server ...
Serving book on http://localhost:4000
```
