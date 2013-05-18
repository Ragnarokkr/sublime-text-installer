# Sublime Text 2 editor installer/uninstaller

This project is partially based on the [work][DamnWidget-work] of [DamnWidget][]
and provides scripts to install and uninstall the [Sublime Text 2][sublime-text]
editor on GNU/Linux distros which don't provide an official repository from which
to install and update the application.


## Requirements

To work, the scripts require that on your system is installed:

- a [FHS][]-compliant GNU/Linux distro (Debian, Ubuntu, Gentoo, etc.)
- a [XDG][]-compliant desktop environment (Gnome, KDE, etc.)
- a [bash][]-compliant shell to execute the script(s)
- [cURL][] to download the archive from the website (many distros already have
  it installed by default, or in their repositories)

It's also required the user to be able to login as root (or use `sudo`),
otherwise the script(s) won't works at all.


## How it works

Once choosen the script that fits your needs, go to a directory to which you
have the read/write permissions (your Downloads directory could be a good choice)
and, from there, call the script with the wanted option. (Just type `-h` or
`--help` for a list of the options.)

For instance, we want Sublime Text to be installed from our Downloads directory.
So, first things first, we have to go to the Downloads directory and download
or fork/clone this repo (I'll use git for this example):

```bash
$ cd ~/Downloads
$ git clone https://github.com/Ragnarokkr/sublime-text-installer.git
```

then we have to choose which one of the scripts fits our needs (currently only
one script is available, anyway), and run it (remember to do it as root or
with `sudo` command) invoking the installation:

```bash
# ./sublime-text-installer/<choosen-script-dir>/install.sh --install
```

That's the order of the actions the script will perform:

1. Pre-check to assure the system we're on is compliant to the requirements
2. Download of the compressed archive from the official website
3. Install binaries and symlinks
4. Install required files for the graphical environment (icons and .desktop file)

To uninstall the program, just run in console:

```bash
# ./sublime-text-installer/<choosen-script-dir>/install.sh --uninstall
```

And the actions performed:

1. Pre-check to assure the system is compliant to the requirements, and
   Sublime Text 2 is installed
2. Request confirmation for the operation
3. Uninstall binaries and symlinks
4. Uninstall graphical environment related files (icons and .desktop file)

**Note: this uninstaller MUST BE invoked ONLY for installations done using the
relative installer.** By using the uninstaller to remove installations done with
`apt-get`, `yum`, `emerge`, etc. can damage your system files.

**Forewarned is forearmed** ;)


## What Write Where

The directory structure used to install the software is compliant to FSH and
XDG standards:

- in `/opt/` is installed the package binaries
- in `/usr/bin/` is installed the package symlinks
- in `/usr/share/applications/` is installed the `.desktop` file
- in `/usr/share/icons/hicolor/` are installed all the `.png`s for the icon


## Testing

These scripts have been successfully tested on:

- GNU/Linux [Sabayon][] (Gentoo-based) with Gnome 3.6+


## Contributing (a.k.a. fork/clone/edit/pull request)

Any contribution to improve the project and/or expand it with new scripts for
other platforms is welcome.

If you're interested in contributing to this project, take care to maintain the
existing coding style.

The project follows these standard, so please you do it too:

* [SemVer][] for version numbers
* [Vandamme][] for changelog formatting
* [EditorConfig][] for cross-editor configuration

To contribute:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

Copyright (C) 2013 Marco Trulla <marco@marcotrulla.it>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a [copy][gnu-license-local] of the GNU General
Public License along with this program.  If not, see
[http://www.gnu.org/licenses/][gnu-license-remote].


[DamnWidget]: https://github.com/DamnWidget
[DamnWidget-work]: https://github.com/DamnWidget/sublime-text

[sublime-text]: http://www.sublimetext.com/
[bash]: http://www.gnu.org/software/bash/manual/bashref.html
[cURL]: http://curl.haxx.se/

[FHS]: http://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
[XDG]: http://en.wikipedia.org/wiki/Freedesktop.org
[SemVer]: http://semver.org/
[Vandamme]: https://github.com/tech-angels/vandamme
[EditorConfig]: http://editorconfig.org/

[Gnome]: http://www.gnome.org/
[Sabayon]: http://www.sabayon.org/

[gnu-license-local]: LICENSE.txt
[gnu-license-remote]: http://www.gnu.org/licenses/
