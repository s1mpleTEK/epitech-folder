# EPITECH-FOLDER

## Table of Contents

- About
- Getting Started
- Usage
- Commands
- Tips
- [License](https://github.com/s1mpleTEK/epitech-folder/blob/master/LICENSE)
- Autor

## About

You all know that a new tool has appeared in the great family that is Epitech Toulouse thanks to Hugo Perez. And this new tool is called, SARA.

As a result, a new way to create your folders is to go through Github !

This is very nice, because lately Blih is a victim of Ddos, a real boomer.

So, I launched myself into the nothingness of programming, to offer you today a very practical script.

What does this script do ? This script will create you a private repository on Github with "ramassage-tls" enabled and clone your repository in the place where the script is executed (Of course for the pickup, you must first have completed Nicolas' questionnaire, which consists of providing him with your nickname GitHub).

Nevertheless, it doesn't just do that, it will create your Blih repository with the functional "ramasage-tek".

We get to the essential point of this script, because in addition to creating your repository on Github as well as on Blih, it will initialize your freshly cloned repository with: a README.md and one .gitignore.

And to make it wonderful, it takes care of setting Blih, of `git add` the two files listed above, of `git commit`: [INIT REPOSITORY], before `git push` the whole thing on: `origin master`, as well as, `blih master`.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Installing

To clone this project, write this command:
``` shell
user:~/$> git clone https://github.com/s1mpleTEK/epitech-folder
```

### Prerequisites

You need to verify that `xdg-open` is on your machine, to do this you need to run this command:
``` shell
user:~/$> whereis xdg-open
```
Now, follow the usage of setup.sh.

## Usage

### setup.sh

After that, you need to set up your computer. For this run:
``` shell
user:~/epitech-folder/$> ./setup.sh
```

### run.sh

To create your repository you must then launch `run.sh`, in the right place for the creation of your repository. Example:
``` shell
user:~/delivery/'Unix System Programming'/$> ../../epitech-folder/./run.sh
```

### reset.sh

If you want change your paramater, you can re-run `setup.sh` or `reset.sh` and `setup.sh` after this.
``` shell
user:~/epitech-folder/$> ./reset.sh
```

## Commands

|   run.sh  |                               Meaning                                       |
|-----------|-----------------------------------------------------------------------------|
|-h --help  | Help for use run.sh                                                         |
|-d --debug | Show debug messages                                                         |
|-u --upgrade| Upgrade epitech-folder repository                                          |

| setup.sh  |                               Meaning                                       |
|-----------|-----------------------------------------------------------------------------|
|-h --help  | Help for use setup.sh                                                       |

| reset.sh  |                               Meaning                                       |
|-----------|-----------------------------------------------------------------------------|
|-h --help  | Help for use reset.sh                                                       |

## Tips
- `run.sh` works as well alone out of the epitech-folder.
- You can upgrade the `epitech-folder` repository with `run.sh -u`
:exclamation: If the file `run.sh` is outside the `epitech-folder` repository, the file `run.sh` who execute the command `-u` or `--upgrade` will not be updated and there will be a new version in the `epitech-folder` repository.

## License
[MIT](https://github.com/s1mpleTEK/epitech-folder/blob/master/LICENSE)
## Author

* **José Rodrigues**, *EPITECH 2024*
