# Lars Web Tools
## Description

Some bash for setting up virtual hosts for Apache in a development environment.

## Example

To create a project and virtual host, run

    user:~/www$ lwt create myproject

Reload Apache with `sudo service apache2 reload` and visit `myproject.localhost` in your favorite browser.

You can delete the project by running `lwt delete <project>` from the same directory where you ran `lwt create <directory>`.

    user:~/www$ lwt delete myproject

## Motivation

Setting up a virtual host involves a few steps:

 * Creating the virtual host configuration.
 * Enabling the virtual host.
 * Adding the virtual host to /etc/hosts so that the domain is mapped to the local computer.

This tool simplifies this process.

### Current implementation

 * Your project files are owned by yourself, not www-data or some other user.
 * If the server needs write permissions for the files in the project, use something like [mpm-itk](http://mpm-itk.sesse.net/) to make Apache run the vhost as yourself.
 * The vhost configuration is located within the project and symlinked to `/etc/apache2/sites-available`.

### The future

 * Add more features like `lwt-rename` and `lwt-default`
 * Create virtual hosts for existing projects.
 * Support more servers, like nginx.
 * Some sort of post-create hooks to e.g. setup databases, install wordpress, intialize composer, create git repo, etc.

## Stability and Security

The code is very unstable. Even though I've tried to handle some common scenarios there may be bugs which can cause irreversible damage. Use at your own risk.

Please don't use this tool to set up a production environment. Your life will be miserable and you'll most definitely get fired.

## Requirements

LWT requires bash and Apache 2.4.

On Ubuntu 14.04, install Apache 2.4 by running

    sudo apt-get install apache2

## Installation

	mkdir ~/src
    cd ~/src
    git clone git@github.com:larsnystrom/lwt.git
    mkdir ~/bin
    ln -s ~/src/lwt/lwt ~/bin/lwt

Verify that you can call `lwt` by running

    which lwt

## Tests

There are no tests at the moment.

## Contribute

If you want to report bugs, request features, changes or enhancements, please open a ticket [here on github](https://github.com/larsnystrom/lwt/issues).

Feel free to open pull requests, but please follow the [editorconfig](http://editorconfig.org/) settings in [.editorconfig](.editorconfig).

## License

MIT License, see [LICENSE](LICENSE).
