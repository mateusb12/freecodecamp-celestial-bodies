#!/bin/bash

DB_NAME="universe"
DB_USER="freecodecamp"
DB_PASS="postgres"
TABLES=("galaxy" "star" "planet" "moon" "asteroid")

psql -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME;"

psql -U $DB_USER -c "CREATE DATABASE $DB_NAME;"

psql -U $DB_USER -d $DB_NAME <<EOF
CREATE TABLE galaxy (
    galaxy_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    galaxy_types VARCHAR(255),
    num_of_stars INT NOT NULL,
    age INT NOT NULL
);

CREATE TABLE star (
    star_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    age_in_millions_of_years INT NOT NULL,
    distance_from_earth FLOAT,
    galaxy_id INT REFERENCES galaxy(galaxy_id) NOT NULL,
    luminosity INT NOT NULL
);

CREATE TABLE planet (
    planet_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    has_life BOOLEAN,
    is_spherical BOOLEAN NOT NULL,
    planet_types VARCHAR(255),
    star_id INT REFERENCES star(star_id) NOT NULL,
    orbital_period INT NOT NULL
);

CREATE TABLE moon (
    moon_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    planet_id INT REFERENCES planet(planet_id) NOT NULL,
    diameter INT NOT NULL,
    mass FLOAT NOT NULL,
    orbital_period INT NOT NULL
);

CREATE TABLE asteroid (
    asteroid_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    size NUMERIC,
    orbit INT NOT NULL
);

INSERT INTO galaxy (name, description, galaxy_types, num_of_stars, age)
VALUES
('Milky Way', 'Our home galaxy', 'Spiral', 100000000, 13700),
('Andromeda', 'Nearest spiral galaxy', 'Spiral', 1000000000, 10000),
('Sombrero', 'Unusual looking galaxy', 'Spiral', 80000000, 9000),
('Triangulum', 'Part of the Local Group', 'Spiral', 40000000, 7500),
('Whirlpool', 'Famous for its spiral structure', 'Spiral', 30000000, 8500),
('Pinwheel', 'Large spiral galaxy', 'Spiral', 70000000, 11000);

INSERT INTO star (name, age_in_millions_of_years, distance_from_earth, galaxy_id, luminosity)
VALUES
('Sun', 4600, 0, 1, 100),
('Alpha Centauri', 5500, 4.37, 1, 150),
('Betelgeuse', 8000, 642.5, 2, 200),
('Vega', 450, 25.04, 3, 120),
('Sirius', 300, 8.6, 4, 130),
('Rigel', 860, 863, 5, 140);

INSERT INTO planet (name, has_life, is_spherical, planet_types, star_id, orbital_period)
VALUES
('Earth', TRUE, TRUE, 'Terrestrial', 1, 365),
('Mars', FALSE, TRUE, 'Terrestrial', 1, 687),
('Jupiter', FALSE, TRUE, 'Gas Giant', 1, 4333),
('Proxima b', NULL, TRUE, 'Exoplanet', 2, 11),
('Kepler-452b', NULL, TRUE, 'Exoplanet', 3, 385),
('Gliese 581d', NULL, TRUE, 'Exoplanet', 3, 67),
('HD 189733 b', FALSE, TRUE, 'Exoplanet', 4, 2.2),
('HD 209458 b', FALSE, TRUE, 'Exoplanet', 4, 3.5),
('55 Cancri e', FALSE, TRUE, 'Exoplanet', 4, 17),
('Kepler-22b', NULL, TRUE, 'Exoplanet', 5, 290),
('Kepler-69c', NULL, TRUE, 'Exoplanet', 5, 242),
('Kepler-62f', NULL, TRUE, 'Exoplanet', 5, 267);

INSERT INTO moon (name, planet_id, diameter, mass, orbital_period)
VALUES
('Moon', 1, 3474, 7.35e22, 27.3),
('Phobos', 2, 22, 1.07e16, 0.3),
('Deimos', 2, 12, 1.48e15, 1.3),
('Europa', 3, 3121, 4.80e22, 3.6),
('Ganymede', 3, 5262, 1.48e23, 7.2),
('Io', 3, 3643, 8.93e22, 1.8),
('Callisto', 3, 4821, 1.08e23, 16.7),
('Titan', 3, 5150, 1.35e23, 15.9),
('Rhea', 3, 1528, 2.31e21, 4.5),
('Tethys', 3, 1060, 6.17e20, 1.9),
('Dione', 3, 1122, 1.05e21, 2.7),
('Iapetus', 3, 1469, 1.80e21, 79.3),
('Mimas', 3, 396, 3.75e19, 0.9),
('Enceladus', 3, 504, 1.08e20, 1.4),
('Hyperion', 3, 270, 5.60e18, 21.3),
('Phoebe', 3, 213, 8.29e18, 18.1),
('Janus', 3, 179, 1.90e18, 0.7),
('Epimetheus', 3, 116, 5.27e17, 0.7),
('Helene', 3, 36, 2.50e16, 2.7),
('Telesto', 3, 24, 1.97e16, 1.9);

INSERT INTO asteroid (name, size, orbit)
VALUES
('Ceres', 945, 4.6),
('Vesta', 525, 3.6),
('Pallas', 512, 4.5),
('Hygeia', 430, 5.6),
('Eros', 34, 1.5);

EOF

# Dump the database schema and data
pg_dump -U $DB_USER -d $DB_NAME -c --inserts > universe.sql

# Display message
echo "Database $DB_NAME created and saved to universe.sql"
