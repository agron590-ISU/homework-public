CREATE TABLE planet 
( "planet_id" INTEGER PRIMARY KEY NOT NULL,
	"name" TEXT NOT NULL,
	"rotation_period" INTEGER,
	"orbital_period" INTEGER,
	"diameter" REAL,
	"climate" TEXT,
	"gravity" TEXT,
	"terrain" TEXT,
	"surface_water" INTEGER,
	"population" INTEGER
);
CREATE TABLE film 
( "film_id" INTEGER PRIMARY KEY NOT NULL,
	"title" TEXT NOT NULL,
	"episode_id" INTEGER NOT NULL,
	"opening_crawl" TEXT,
	"producer" TEXT,
	"release_date" TEXT
);
CREATE TABLE vehicle 
( "vehicle_id" INTEGER PRIMARY KEY NOT NULL,
	"name" TEXT NOT NULL,
	"model" TEXT,
	"manufacturer" TEXT,
	"cost_in_credits" INTEGER,
	"length" REAL,
	"max_atmosphering_speed" INTEGER,
	"crew" INTEGER,
	"passengers" INTEGER,
	"cargo_capacity" INTEGER,
	"consumables" TEXT,
	"vehicle_class" TEXT 
);
CREATE TABLE starship 
( "starship_id" INTEGER PRIMARY KEY NOT NULL,
	"name" TEXT NOT NULL,
	"model" TEXT,
	"manufacturer" TEXT,
	"cost_in_credits" INTEGER,
	"length" REAL,
	"max_atmosphering_speed" INTEGER,
	"crew" INTEGER,
	"passengers" INTEGER,
	"cargo_capacity" INTEGER,
	"consumables" TEXT,
	"hyperdrive_rating" REAL,
	"MGLT" REAL,
	"starship_class" TEXT 
);
CREATE TABLE person 
( "person_id" INTEGER PRIMARY KEY NOT NULL,
	"name" TEXT NOT NULL,
	"height" REAL,
	"mass" REAL,
	"hair_color" TEXT,
	"skin_color" TEXT,
	"eye_color" TEXT,
	"birth_year" TEXT,
	"gender" TEXT,
	"homeworld_id" INTEGER,
	"species_id" INTEGER,
		FOREIGN KEY (homeworld_id) REFERENCES planet(planet_id),
	    FOREIGN KEY (species_id) REFERENCES species(species_id)
);
CREATE TABLE species 
( "species_id" INTEGER PRIMARY KEY NOT NULL,
	"name" TEXT NOT NULL,
	"classification" TEXT,
	"designation" TEXT,
	"average_height" REAL,
	"skin_colors" TEXT,
	"hair_colors" TEXT,
	"eye_colors" TEXT,
	"average_lifespan" REAL,
	"language" TEXT,
	"homeworld_id" REAL,
	    FOREIGN KEY (homeworld_id) REFERENCES planet(planet_id)
);
CREATE TABLE residence 
( "planet_id" NOT NULL,
	"person_id" NOT NULL,
		FOREIGN KEY (planet_id) REFERENCES planet(planet_id),
	    FOREIGN KEY (person_id) REFERENCES person(person_id)
);
CREATE TABLE pilot 
( "craft_id" INTEGER NOT NULL,
	"craft_type" TEXT NOT NULL,
	"pilot_id" INTEGER NOT NULL,
		FOREIGN KEY (craft_id) REFERENCES starship(starship_id),
        FOREIGN KEY (craft_id) REFERENCES vehicle(vehicle_id),
	    FOREIGN KEY (pilot_id) REFERENCES person(person_id)
);
CREATE TABLE film_includes 
( "film_id" INTEGER NOT NULL,
	"includes_id" INTEGER NOT NULL,
	"includes_type" TEXT NOT NULL,
		FOREIGN KEY (film_id) REFERENCES film(film_id),
	    FOREIGN KEY (includes_id) REFERENCES person(person_id),
	    FOREIGN KEY (includes_id) REFERENCES planet(planet_id),
	    FOREIGN KEY (includes_id) REFERENCES starship(starship_id),
      FOREIGN KEY (includes_id) REFERENCES vehicle(vehicle_id)
);
