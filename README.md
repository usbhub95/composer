<!-- composer -->
<a id="readme-top"></a>

<!-- shields -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GNU GPLv3][license-shield]][license-url]

<!-- readme head -->
<h3 align="center">project_title</h3>

  <p align="center">
    Interactive script that installs Docker and predefined containers in a group with a command to manage them.
    <br />
    <a href="https://github.com/usbhub95/composer/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/usbhub95/composer/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

I made this so I could set up my home server easily and do the same for my friends and family.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

This was created and tested on a Debian 12 machine with only the `standard tools` and `ssh` packages installed.

### Prerequisites

*   Git
    ```sh
    sudo apt install git
    ```

### Installation

1.  Create the installation directory
    ```sh
    sudo mkdir -p "~/homeserv"
    sudo chown -R $USER:$USER "~/homeserv"
    ```
2.  Clone the repository to a temporary location
    ```sh
    git clone --depth=1 https://github.com/usbhub95/composer.git /tmp/composer
    ```
3.  Run `install.sh`
    ```sh
    cd /tmp/composer
    bash install.sh
    ```
4.  Follow the insructions in the script

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Use the group command as follows (homeserv as example):
```sh
user@homeserv:~$ homeserv
homeserv - docker group
Usage: homeserv [--help|restart|stop|start|disable]
options:
--help     displays this help message
restart    restarts all homeserv containers
stop       stops all homeserv containers
start      starts and enables all homeserv containers and services
disable    stops and disables all homeserv containers and services
user@homeserv:~$
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the GNU GPLv3 License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Cooper Lockrey - cooper.lockrey@gmail.com

Project Link: [https://github.com/usbhub95/composer](https://github.com/usbhub95/composer)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [YAMS](https://gitlab.com/rogs/yams)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/usbhub95/composer.svg?style=for-the-badge
[contributors-url]: https://github.com/usbhub95/composer/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/usbhub95/composer.svg?style=for-the-badge
[forks-url]: https://github.com/usbhub95/composer/network/members
[stars-shield]: https://img.shields.io/github/stars/usbhub95/composer.svg?style=for-the-badge
[stars-url]: https://github.com/usbhub95/composer/stargazers
[issues-shield]: https://img.shields.io/github/issues/usbhub95/composer.svg?style=for-the-badge
[issues-url]: https://github.com/usbhub95/composer/issues
[license-shield]: https://img.shields.io/github/license/usbhub95/composer.svg?style=for-the-badge
[license-url]: https://github.com/usbhub95/composer/blob/master/LICENSE.txt