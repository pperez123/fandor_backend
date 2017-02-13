# Fandor Back-end Coding Challenge

The coding challenge entailed developing a simple web API to show and update sample film data. 
The developer chose the Ruby on Rails web development framework for implementation of the challenge requirements:
 - RESTful endpoints for retrieving a list of films or an individual film
 - Support for allowing a user to rate a specific film
 - Include average rating for a film as one of its attributes
 - Requests and responses should follow the [JSON API specification](http://jsonapi.org/)

##Films API

The primary endpoint for the supported film data operations is "/api/films".
This endpoint supports GET and PUT RESTful operations related to retrieving the full list of films,
a single film, and allowing a user to rate a film.

###List of Films

`GET /api/films{?fields[films],sort}`

Example:

`GET http://localhost:3000/api/films?sort=-average_rating,-year,title&fields[film]=title,description`

####URI Parameters (Optional)

* fields[film] (String) - Allows the client to specify which film attributes to include
in the result set. Possible values include: title, description, url_slug, year
related_film_ids, and average_rating.
* sort (String) - List of film attributes used to sort the result set. The sort fields are
 applied in the order specified. The sort order for each field is ascending unless prefixed with
 a minus/hyphen ("-"), in which case it will be in descending order.

####Description

To retrieve the list of all films, the client sends a GET request to "/api/films".
If successful, the client will receive a 200 response with a JSON data payload 
containing an array of film objects. Each film entity contains the film id, 
api data type, and attributes. 

One of the attributes returned with the film properties
set is "average_rating". This value is computed by taking the average of all user
ratings in the film_ratings table for a film. API to set a rating
is described later in this documentation.

An empty array will be returned for no results. 

####Sample Response

```json
{
"data": [
    {
        "id": 1,
        "properties": {
            "title": "A Wonderful Film",
            "description": "A cute film about lots of wonderful stuff.",
            "url_slug": "a_wonderful_film",
            "year": 1973,
            "related_film_ids": [
              2,
              4,
              7
            ],
            "average_rating": 4.75
        },
        "type": "film"
    },
    {
        "id": 2,
        "properties": {
            "title": "All About Fandor",
            "description": "Documentary telling the tail of Fandor.",
            "url_slug": "all_about_fandor",
            "year": 2001,
            "related_film_ids": [
                1,
                4,
                7
            ],
            "average_rating": 0
        },
        "type": "film"
    },
    ...
  ]
}
```

### Retrieving one film

`GET /api/films/{id}{?fields[film]}`

or

`GET http://localhost:3000/api/films/1?fields[film]=title,description`

####URI Parameters (Optional)

* fields[film] (String) - Allows the client to specify which film attributes to include
in the result set. Possible values include: title, description, url_slug, year
related_film_ids, and average_rating.

####Description

To retrieve data on a single film, the client sends a GET request to "/api/films/"
and appends the id of the requested film. If the film exists, the client receives a JSON
payload containing the film id, api data type, and attributes, including a list of 
id's for related films and the average user rating.

####Errors
* 404 Not Found - If movie with submitted id does not exist, the client will get a JSON error message: "Film not found."

####Sample Response

```json
{
"data": {
    "id": 1,
    "properties": {
        "title": "A Wonderful Film",
        "description": "A cute film about lots of wonderful stuff.",
        "url_slug": "a_wonderful_film",
        "year": 1973,
        "related_film_ids": [
            2,
            4,
            7
        ],
        "average_rating": 4.75
    },
    "type": "film"
  }
}
```

###Rating a Specific Film

`PUT /api/films/{id}`

or 

`PUT http://localhost:3000/api/films/1`

To allow a user to rate a specific film, the client sends a PUT request to "/api/films/"
and appends the film's id. The request must also contain a properly formatted json body.

####Request
The request should contain the following header:

`Content-Type: application/json`

The body of the request should be formatted in JSON as follows:

```json
{
  "data": {
    "id": "1",
    "attributes": {
      "user_id" : 4,
      "rating": 7
    }
  }
}
```
* _id_ - Id of film to set the rating for.
* _user_id_ - Id of user that is rating the film.
* _rating_ - Numerical rating value.

####Errors
* 404 Not Found - If the movie to rate does not exist the client will receive a "Film not 
found." error message.
* 406 Not Acceptable - If the user_id parameter is missing from the request, 
the rating process will abort with a "No user id for rating." error message.

####Sample Response
If the rating process is successful, the client will receive a JSON response like the following:

```json
{
  "data": {
    "status": "Success"
  }
}
```
