## libraries ------------
library(rwars)

## functions to take lists to tables ----------------
format_planets <- function(planets) {
  planet <- lapply(planets$results, function(p) {
    row <- unlist(p)
    row[c("name", "rotation_period", "orbital_period", "diameter", "climate", "gravity", "terrain", "surface_water", "population", "url")]  
  })
  planet <- data.frame(do.call(rbind, planet), stringsAsFactors = FALSE)
  
  #format variables
  planet$rotation_period <- as.numeric(planet$rotation_period)
  planet$orbital_period <- as.numeric(planet$orbital_period)
  planet$diameter <- as.numeric(planet$diameter)
  planet$surface_water <- as.numeric(planet$surface_water)
  planet$population <- as.numeric(planet$population)
  
  data.frame(planet_id = as.numeric(unlist(lapply(strsplit(planet$url, "/"), function(x) x[6]))), 
             planet[, names(planet) != "url"])
}

format_films <- function(films) {
  film <- lapply(films$results, function(p) {
    row <- unlist(p)
    row[c("title", "episode_id", "opening_crawl", "producer", "release_date", "url")] 
  })
  film <- data.frame(do.call(rbind, film), stringsAsFactors = FALSE)
  
  #format variables
  film$episode_id <- as.numeric(film$episode_id)
  film$release_date <- film$release_date
  
  data.frame(film_id = as.numeric(unlist(lapply(strsplit(film$url, "/"), function(x) x[6]))), 
             film[, names(film) != "url"])
}

format_vehicles <- function(vehicles) {
  vehicle <- lapply(vehicles$results, function(p) {
    row <- unlist(p)
    row[c("name", "model", "manufacturer", "cost_in_credits", "length", "max_atmosphering_speed", "crew", "passengers", "cargo_capacity", "consumables", "vehicle_class", "url")] 
  })
  vehicle <- data.frame(do.call(rbind, vehicle), stringsAsFactors = FALSE)
  
  #format variables
  vehicle$cost_in_credits <- as.numeric(vehicle$cost_in_credits)
  vehicle$length <- as.numeric(vehicle$length)
  vehicle$max_atmosphering_speed <- as.numeric(vehicle$max_atmosphering_speed)
  vehicle$crew <- as.numeric(vehicle$crew)
  vehicle$passengers <- as.numeric(vehicle$passengers)
  vehicle$cargo_capacity <- as.numeric(vehicle$cargo_capacity)
  
  data.frame(vehicle_id = as.numeric(unlist(lapply(strsplit(vehicle$url, "/"), function(x) x[6]))), 
             vehicle[, names(vehicle) != "url"])
}

format_starships <- function(starships) {
  starship <- lapply(starships$results, function(p) {
    row <- unlist(p)
    row[c("name", "model", "manufacturer", "cost_in_credits", "length", "max_atmosphering_speed", "crew", "passengers", "cargo_capacity", "consumables", "hyperdrive_rating", "MGLT", "starship_class", "url")] 
  })
  starship <- data.frame(do.call(rbind, starship), stringsAsFactors = FALSE)
  
  #format variables
  starship$cost_in_credits <- as.numeric(starship$cost_in_credits)
  starship$length <- as.numeric(starship$length)
  starship$max_atmosphering_speed <- as.numeric(starship$max_atmosphering_speed)
  starship$crew <- as.numeric(starship$crew)
  starship$passengers <- as.numeric(starship$passengers)
  starship$cargo_capacity <- as.numeric(starship$cargo_capacity)
  starship$hyperdrive_rating <- as.numeric(starship$hyperdrive_rating)
  starship$MGLT <- as.numeric(starship$MGLT)
  
  data.frame(starship_id = as.numeric(unlist(lapply(strsplit(starship$url, "/"), function(x) x[6]))), 
             starship[, names(starship) != "url"])
}

format_people <- function(people) {
  person <- lapply(people$results, function(p) {
    row <- unlist(p)
    row[c("name", "height", "mass", "hair_color", "skin_color", "eye_color", "birth_year", "gender", "homeworld", "species", "url")] 
  })
  person <- data.frame(do.call(rbind, person), stringsAsFactors = FALSE)
  
  #format variables
  person$height <- as.numeric(person$height)
  person$mass <- as.numeric(person$mass)
  
  data.frame(person_id = as.numeric(unlist(lapply(strsplit(person$url, "/"), function(x) x[6]))), 
             person[, !(names(person) %in% c("url", "homeworld", "species"))],
             homeworld_id = as.numeric(unlist(lapply(strsplit(person$homeworld, "/"), function(x) x[6]))),
             species_id = as.numeric(unlist(lapply(strsplit(person$species, "/"), function(x) x[6]))))
}

format_species <- function(speciess) {
  species <- lapply(speciess$results, function(p) {
    row <- unlist(p)
    row[c("name", "classification", "designation", "average_height", "skin_colors", "hair_colors", "eye_colors", "average_lifespan", "homeworld", "language", "url")] 
  })
  species <- data.frame(do.call(rbind, species), stringsAsFactors = FALSE)
  
  #format variables
  species$average_height <- as.numeric(species$average_height)
  species$average_lifespan <- as.numeric(species$average_lifespan)
  
  data.frame(species_id = as.numeric(unlist(lapply(strsplit(species$url, "/"), function(x) x[6]))), 
             species[, !(names(species) %in% c("url", "homeworld"))],
             homeworld_id = as.numeric(unlist(lapply(strsplit(species$homeworld, "/"), function(x) x[6]))))
}


## residence (planet_person)
format_residence <- function(planets) {
  residence <- lapply(planets$results, function(p){
    if(length(p$residents) > 0) {
      people <- as.numeric(unlist(lapply(strsplit(p$residents, "/"), function(x) x[6])))
      place <- rep(as.numeric(unlist(lapply(strsplit(p$url, "/"), function(x) x[6]))), length(people))
    } else {
      people <- place <- NULL
    }
    data.frame(planet_id = place,
               person_id = people)
  })
  do.call(rbind, residence)
}

## pilot (person_vehicle & person_starship)
format_pilot <- function(vehicles, starships) {
  v_pilot <- lapply(vehicles$results, function(p) {
    if(length(p$pilots) > 0) {
      pilots <- as.numeric(unlist(lapply(strsplit(p$pilots, "/"), function(x) x[6])))
      crafts <- rep(as.numeric(unlist(lapply(strsplit(p$url, "/"), function(x) x[6]))), length(pilots))
      type <- rep("vehicle", length(pilots))
    } else {
      pilots <- crafts <- type <- NULL
    }
    data.frame(craft_id = crafts,
               craft_type = type,
               pilot_id = pilots)
  })
  s_pilot <- lapply(starships$results, function(p) {
    if(length(p$pilots) > 0) {
      pilots <- as.numeric(unlist(lapply(strsplit(p$pilots, "/"), function(x) x[6])))
      crafts <- rep(as.numeric(unlist(lapply(strsplit(p$url, "/"), function(x) x[6]))), length(pilots))
      type <- rep("starship", length(pilots))
    } else {
      pilots <- crafts <- type <- NULL
    }
    data.frame(craft_id = crafts,
               craft_type = type,
               pilot_id = pilots)
  })
  rbind(do.call(rbind, v_pilot), do.call(rbind, s_pilot))
}

## film_includes (planet, people, vehicle, starship)
format_film_includes <- function(films) {
  film_includes <- lapply(films$results, function(p) {
    res <- data.frame()
    
    if(length(p$planets) > 0) {
      planets <- as.numeric(unlist(lapply(strsplit(p$planets, "/"), function(x) x[6])))
      res <- rbind(res, 
                   data.frame(includes_id = planets, includes_type = "planet")
      )
    }
    
    if(length(p$characters) > 0) {
      people <- as.numeric(unlist(lapply(strsplit(p$characters, "/"), function(x) x[6])))
      res <- rbind(res, 
                   data.frame(includes_id = people, includes_type = "person")
      )
    } 
    
    if(length(p$vehicles) > 0) {
      vehicles <- as.numeric(unlist(lapply(strsplit(p$vehicles, "/"), function(x) x[6])))
      res <- rbind(res, 
                   data.frame(includes_id = vehicles, includes_type = "vehicle")
      )
    } 
    
    if(length(p$starships) > 0) {
      starships <- as.numeric(unlist(lapply(strsplit(p$starships, "/"), function(x) x[6])))
      res <- rbind(res, 
                   data.frame(includes_id = starships, includes_type = "starship")
      )
    } 
    data.frame(film_id = as.numeric(unlist(lapply(strsplit(p$url, "/"), function(x) x[6]))), res)
  })
  do.call(rbind, film_includes)
  
}



## get and format data -------------
## these are not complete, need to set up function to pull everything down
## planets 
planets <- get_all_planets(parse_result = TRUE)
while(!is.null(planets$`next`)) {
  planets2 <- get_all_planets(getElement(planets, "next"), parse_result = TRUE)
  planets$`next` <- planets2$`next`
  planets$results <- c(planets$results, planets2$results)
}
planet <- format_planets(planets)
planet <- unique(planet)

## films
films <- get_all_films(parse_result = TRUE)
while(!is.null(films$`next`)) {
  films2 <- get_all_films(getElement(films, "next"), parse_result = TRUE)
  films$`next` <- films2$`next`
  films$results <- c(films$results, films2$results)
}
film <- format_films(films)
film <- unique(film)

## vehicles
vehicles <- get_all_vehicles(parse_result = TRUE)
while(!is.null(vehicles$`next`)) {
  vehicles2 <- get_all_vehicles(getElement(vehicles, "next"), parse_result = TRUE)
  vehicles$`next` <- vehicles2$`next`
  vehicles$results <- c(vehicles$results, vehicles2$results)
}
vehicle <- format_vehicles(vehicles)
vehicle <- unique(vehicle)

## starships
starships <- get_all_starships(parse_result = TRUE)
while(!is.null(starships$`next`)) {
  starships2 <- get_all_starships(getElement(starships, "next"), parse_result = TRUE)
  starships$`next` <- starships2$`next`
  starships$results <- c(starships$results, starships2$results)
}
starship <- format_starships(starships)
starship <- unique(starship)

## people
people <- get_all_people(parse_result = TRUE)
while(!is.null(people$`next`)) {
  people2 <- get_all_people(getElement(people, "next"), parse_result = TRUE)
  people$`next` <- people2$`next`
  people$results <- c(people$results, people2$results)
}
person <- format_people(people)
person <- unique(person)

## species
speciess <- get_all_species(parse_result = TRUE)
while(!is.null(speciess$`next`)) {
  speciess2 <- get_all_species(getElement(speciess, "next"), parse_result = TRUE)
  speciess$`next` <- speciess2$`next`
  speciess$results <- c(speciess$results, speciess2$results)
}
species <- format_species(speciess)
species <- unique(species)

## residence (planet_person)
residence <- format_residence(planets)

## pilot (person_vehicle & person_starship)
pilot <- format_pilot(vehicles, starships)

## film_includes (planet, person, vehicle, starship)
film_includes <- format_film_includes(films)

## make db ----------------
## db has already been created with schema in SQLite
library(DBI)
con <- dbConnect(RSQLite::SQLite(), "data/star_wars.db")

## add rows to existing tables
dbWriteTable(con, "planet", planet, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "film", film, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "vehicle", vehicle, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "starship", starship, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "person", person, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "species", species, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "residence", residence, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "pilot", pilot, overwrite = FALSE, append = TRUE)
dbWriteTable(con, "film_includes", film_includes, overwrite = FALSE, append = TRUE)

dbDisconnect(con)
