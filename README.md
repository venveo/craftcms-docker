# Docker Build for Craft CMS

Our starter project for Docker powered Craft CMS websites

## Installation

1. Clone the respository into the a new project (e.g `our-company-website`)
2. `cd` to `our-company-website` and run `make craft`. This will use composer to create new new Craft CMS project into the `craft` directory
3. Open `Makefile` and change `COMPANY`, `PROJECT`, `DB_USER` and `DB_PASSWORD` to meet your requirements
4. Run `make build`. This will create a new Docker image using the Company and Project name (e.g venveo/new-project)
5. Rename the `craft/web` directory to `craft/html`. This is temporary and may change in the future
6. After the build completes, run the command `make run`. This will create three new containers. One for PHP Apache, Postgres and MySQL
6. Open up a browser and visit [http://localhost/index.php/admin/install](http://localhost/index.php/admin/install)

### Makefile

#### make craft

Uses composer to create a new Craft CMS inside the `craft` directory.

#### make build

Run the `docker build` command to create a new image for the Company/Project namespace.

#### make run

Run the Docker containers for the web and databases.

#### make ssh

Run `docker exec` to "ssh" into the webserver and drop you into a bash shell

#### make stop

Run `docker stop` on each container. 

### To Dos

1. Setup Lets Encrypt for local HTTPS websites
2. Cleanup the `Makefile` to be able to select MySQL or Postgres as the database
3. Update and improve the documentation

## Credits

* [Jason McCallister](https://github.com/themccallister)

## About Venveo

Venveo is a Digital Marketing Agency for Building Materials Companies in Blacksburg, VA. Learn more about us on [our website](https://www.venveo.com).

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
