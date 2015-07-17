## JsonLang Documentation
The full url is http://iqstack.github.io/jsonlang
From there you can click on the docs section


Note: This is a branch of jsonnet but it will not show up on the project if you clone jsonlang. This was created by the following so that it keeps all of the docs and html separate from the source code for clarity:

1. Clone https://github.com/iqstack/jsonlang
2. git checkout iqstack
3. mkdir gh-pages
4. cd gh-pages
5. git init
6. git remote add origin https://github.com/iqstack
7. git pull origin gh-pages
8. You may have a master branch created automatically but you can get rid of it like so:
    a. git checkout gh-pages
    b. git branch remove -D master
9. You should have just the gh-pages branch as the only branch in this new sub-directory.
10. cd ..
11. vim .gitignore and add: gh-pages/ as the first line (could be anywhere and use any editor you please). By adding gh-pages to the .gitignore the main jsonnet area will not try to check it in and then you can easily control it from the gh-pages sub-directory.
12. In the main project directory (one above gh-pages), you can update the doc directory with any new documentation and then simply copy it to gh-pages/docs.
13. When ready to check gh-pages back in do: (assuming in gh-pages directory)
    a. git commit -am "whatever message you want"
    b. git push origin gh-pages

Now you can keep your site/docs separated but have them show up in github as a separate branch and not a new project.
