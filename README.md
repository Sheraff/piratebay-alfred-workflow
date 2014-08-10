piratebay-alfred-workflow
=========================

## summary
This is a workflow for [Alfred App](http://www.alfredapp.com/ “Alfred App official website”) (Mac OSX) to crawl [piratebay](http://thepiratebay.se/ “the pirate bay”) and return magnet links with proper information.

## quick use
Just download the [`Piratebay.alfredworkflow` file](https://github.com/Sheraff/piratebay-alfred-workflow/blob/master/Piratebay.alfredworkflow?raw=true “link to direct download”) and open with Alfred.

Alternatively, use `Packal` through [the website](http://www.packal.org/workflow/piratebay “link to the workflow’s Packal page”) or through the Alfred workflow.

## overview of the workflow
This is a quick draft of a remodeled version of a piratebay workflow for Alfred App. APIfy is closing and we need an alternative. Don't hesitate to collaborate, there is a lot that could be improved.

### This project uses
- [David Ferguson's `workflows` php class](http://dferg.us/workflows-class/ "Workflows Class")
- [Mafintosh's `peerflix` node](https://github.com/mafintosh/peerflix "peerflix on github") for NodeJS

### Improvement ideas are
- visible history of previous downloads (any previously triggered magnet appears with a checked box)
- only add the 'streaming' alternative if the user has peerflix and nodejs installed
- create a quick tutorial (or refer to one) on how to install nodejs and peerflix
- deal with deleting from cache / writing to cache (in `main_script.php`) in a separate thread to prevent slow downs

## detailed view of the various files
- `main_script.php` is the main script behind everything. It parses the query, goes through the cache (2 hours) & archive (2 days) and eventually fetches and crawls piratebay if necessary (and writes the result in cache).
- `clean_cache.php` is a script run after every validation (when the user presses enter with none or any of the modifier keys). It cleans the cache based on expiration date (set to 2 days). It is only run after the execution to prevent slowing down the display of results.
- `secondary_script_example.php` unserializes the argument passed by Alfred and sends it to the next script.
- `workflows.php` is David Ferguson’s