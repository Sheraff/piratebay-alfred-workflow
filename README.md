piratebay-alfred-workflow
=========================

workflow for Alfred App to crawl piratebay and return magnet links

This is a quick draft of a remodeled version of a piratebay workflow for Alfred App. APIfy is closing and we need an alternative. Don't hesitate to collaborate, there is a lot that could be improved.

This project uses
- [David Ferguson's `workflows` php class](http://dferg.us/workflows-class/ "Workflows Class")
- [Mafintosh's `peerflix` node](https://github.com/mafintosh/peerflix "peerflix on github") for NodeJS

Improvement ideas are
- visible history of previous downloads (any previously triggered magnet appears with a checked box)
- only add the 'streaming' alternative if the user has peerflix and nodejs installed
- create a quick tutorial (or refer to one) on how to install nodejs and peerflix
