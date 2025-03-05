# FCM Digital - Ruby Technical challenge

This repository was created as the Ruby technical challenge for FCM Digital

## Table of Contents
- [Task description](#task-description)
- [Assumptions](#assumptions)
- [Proposed solution](#proposed-solution)

### Task description 
As we want to provide a better experience for our users we want to represent their itinerary in the most comprehensive way possible.

We receive the reservations of our user that we know is based on SVQ as:
```
# input.txt
RESERVATION
SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10

RESERVATION
SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

RESERVATION
SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

RESERVATION
SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

RESERVATION
SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17

RESERVATION
SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
```
But we run a command like BASED=SVQ bundle exec ruby main.rb input.txt want to expose and UI like this:
```
TRIP to BCN
Flight from SVQ to BCN at 2023-01-05 20:40 to 22:10
Hotel at BCN on 2023-01-05 to 2023-01-10
Flight from BCN to SVQ at 2023-01-10 10:30 to 11:50

TRIP to MAD
Train from SVQ to MAD at 2023-02-15 09:30 to 11:00
Hotel at MAD on 2023-02-15 to 2023-02-17
Train from MAD to SVQ at 2023-02-17 17:00 to 19:30

TRIP to NYC
Flight from SVQ to BCN at 2023-03-02 06:40 to 09:10
Flight from BCN to NYC at 2023-03-02 15:00 to 22:45
```
### Assumptions; 
- For the program to run we need to feed the script two arguments, the base city of the user under BASED and the input file in txt format
- The script will run using the following command
`BASED=SVQ bundle exec ruby main.rb input.txt`
- An input file contains lines starting with RESERVATIONS and SEGMENTS
- The lines starting with RESERVATIONS can be ignored for now
- The segments don’t overlap 
- The segments in the input file don’t follow any logic, segments are not chronologically ordered
- A segment is considered Unknown if it’s not related to flights, trains or hotels. 
- A round trip is when two transportation segments share the same origin and destination 
- A matching trip is when the origin or destination of the segment matches as well as the arrival and departure of said destination, this way we can match transportation segments (flights or trains) with accommodations (hotels) 
- We consider two flights to be a connection if they happen within the same day

### Proposed solution
To run the task use this command in the root of the project;\
`BASED=SVQ bundle exec rake "trip:parser[input.txt]"`

The entry point of the solution will be a rake task accepting two parameters, the base city of the user, SVQ for example, and an input file with the segments of the trips.\
The rake has a basic presence validation for the parameters, returning an error if no city is provided and using an example file (input.txt) if no file is passed to the rake task.
If the parameters are provided, the rake task will call the `TripService`.\
The `TripService` will first parse each line of the file and save it into an instance called `@segments`.\
We are parsing each line based on the type of segment; Flight, Train and Hotel for now. Each of those services will return a hash containing all the information related to the specific segment for their grouping later on.
