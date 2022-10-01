CREATE TABLE IF NOT EXISTS public.aircrafts
(
    aircraft_code character(3) COLLATE pg_catalog."default" NOT NULL,
    model jsonb NOT NULL,
    range integer NOT NULL,
    CONSTRAINT aircrafts_pkey PRIMARY KEY (aircraft_code),
    CONSTRAINT aircrafts_range_check CHECK (range > 0)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.aircrafts
    OWNER to postgres;

COMMENT ON TABLE public.aircrafts
    IS 'Aircrafts (internal data)';

COMMENT ON COLUMN public.aircrafts.aircraft_code
    IS 'Aircraft code, IATA';

COMMENT ON COLUMN public.aircrafts.model
    IS 'Aircraft model';

COMMENT ON COLUMN public.aircrafts.range
    IS 'Maximal flying distance, km';


CREATE TABLE IF NOT EXISTS public.airports
(
    airport_code character(3) COLLATE pg_catalog."default" NOT NULL,
    airport_name jsonb NOT NULL,
    city jsonb NOT NULL,
    coordinates point NOT NULL,
    timezone text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT airports_data_pkey PRIMARY KEY (airport_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.airports
    OWNER to postgres;

COMMENT ON TABLE public.airports
    IS 'Airports (internal data)';

COMMENT ON COLUMN public.airports.airport_code
    IS 'Airport code';

COMMENT ON COLUMN public.airports.airport_name
    IS 'Airport name';

COMMENT ON COLUMN public.airports.city
    IS 'City';

COMMENT ON COLUMN public.airports.coordinates
    IS 'Airport coordinates (longitude and latitude)';

COMMENT ON COLUMN public.airports.timezone
    IS 'Airport time zone';


CREATE TABLE IF NOT EXISTS public.boarding_passes
(
    ticket_no character(13) COLLATE pg_catalog."default" NOT NULL,
    flight_id integer NOT NULL,
    boarding_no integer NOT NULL,
    seat_no character varying(4) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT boarding_passes_pkey PRIMARY KEY (ticket_no, flight_id),
    CONSTRAINT boarding_passes_flight_id_boarding_no_key UNIQUE (flight_id, boarding_no),
    CONSTRAINT boarding_passes_flight_id_seat_no_key UNIQUE (flight_id, seat_no),
    CONSTRAINT boarding_passes_ticket_no_fkey FOREIGN KEY (flight_id, ticket_no)
        REFERENCES public.ticket_flights (flight_id, ticket_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.boarding_passes
    OWNER to postgres;

COMMENT ON TABLE public.boarding_passes
    IS 'Boarding passes';

COMMENT ON COLUMN public.boarding_passes.ticket_no
    IS 'Ticket number';

COMMENT ON COLUMN public.boarding_passes.flight_id
    IS 'Flight ID';

COMMENT ON COLUMN public.boarding_passes.boarding_no
    IS 'Boarding pass number';

COMMENT ON COLUMN public.boarding_passes.seat_no
    IS 'Seat number';




CREATE TABLE IF NOT EXISTS public.bookings
(
    book_ref character(6) COLLATE pg_catalog."default" NOT NULL,
    book_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    CONSTRAINT bookings_pkey PRIMARY KEY (book_ref)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.bookings
    OWNER to postgres;

COMMENT ON TABLE public.bookings
    IS 'Bookings';

COMMENT ON COLUMN public.bookings.book_ref
    IS 'Booking number';

COMMENT ON COLUMN public.bookings.book_date
    IS 'Booking date';

COMMENT ON COLUMN public.bookings.total_amount
    IS 'Total booking cost';


-- Table: public.flights

-- DROP TABLE IF EXISTS public.flights;

CREATE TABLE IF NOT EXISTS public.flights
(
    flight_id integer NOT NULL DEFAULT nextval('flights_flight_id_seq'::regclass),
    flight_no character(6) COLLATE pg_catalog."default" NOT NULL,
    scheduled_departure timestamp with time zone NOT NULL,
    scheduled_arrival timestamp with time zone NOT NULL,
    departure_airport character(3) COLLATE pg_catalog."default" NOT NULL,
    arrival_airport character(3) COLLATE pg_catalog."default" NOT NULL,
    status character varying(20) COLLATE pg_catalog."default" NOT NULL,
    aircraft_code character(3) COLLATE pg_catalog."default" NOT NULL,
    actual_departure timestamp with time zone,
    actual_arrival timestamp with time zone,
    CONSTRAINT flights_pkey PRIMARY KEY (flight_id),
    CONSTRAINT flights_flight_no_scheduled_departure_key UNIQUE (flight_no, scheduled_departure),
    CONSTRAINT flights_aircraft_code_fkey FOREIGN KEY (aircraft_code)
        REFERENCES public.aircrafts (aircraft_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT flights_arrival_airport_fkey FOREIGN KEY (arrival_airport)
        REFERENCES public.airports (airport_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT flights_departure_airport_fkey FOREIGN KEY (departure_airport)
        REFERENCES public.airports (airport_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT flights_check CHECK (scheduled_arrival > scheduled_departure),
    CONSTRAINT flights_check1 CHECK (actual_arrival IS NULL OR actual_departure IS NOT NULL AND actual_arrival IS NOT NULL AND actual_arrival > actual_departure),
    CONSTRAINT flights_status_check CHECK (status::text = ANY (ARRAY['On Time'::character varying::text, 'Delayed'::character varying::text, 'Departed'::character varying::text, 'Arrived'::character varying::text, 'Scheduled'::character varying::text, 'Cancelled'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.flights
    OWNER to postgres;

COMMENT ON TABLE public.flights
    IS 'Flights';

COMMENT ON COLUMN public.flights.flight_id
    IS 'Flight ID';

COMMENT ON COLUMN public.flights.flight_no
    IS 'Flight number';

COMMENT ON COLUMN public.flights.scheduled_departure
    IS 'Scheduled departure time';

COMMENT ON COLUMN public.flights.scheduled_arrival
    IS 'Scheduled arrival time';

COMMENT ON COLUMN public.flights.departure_airport
    IS 'Airport of departure';

COMMENT ON COLUMN public.flights.arrival_airport
    IS 'Airport of arrival';

COMMENT ON COLUMN public.flights.status
    IS 'Flight status';

COMMENT ON COLUMN public.flights.aircraft_code
    IS 'Aircraft code, IATA';

COMMENT ON COLUMN public.flights.actual_departure
    IS 'Actual departure time';

COMMENT ON COLUMN public.flights.actual_arrival
    IS 'Actual arrival time';


-- Table: public.seats

-- DROP TABLE IF EXISTS public.seats;

CREATE TABLE IF NOT EXISTS public.seats
(
    aircraft_code character(3) COLLATE pg_catalog."default" NOT NULL,
    seat_no character varying(4) COLLATE pg_catalog."default" NOT NULL,
    fare_conditions character varying(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT seats_pkey PRIMARY KEY (aircraft_code, seat_no),
    CONSTRAINT seats_aircraft_code_fkey FOREIGN KEY (aircraft_code)
        REFERENCES public.aircrafts (aircraft_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT seats_fare_conditions_check CHECK (fare_conditions::text = ANY (ARRAY['Economy'::character varying::text, 'Comfort'::character varying::text, 'Business'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.seats
    OWNER to postgres;

COMMENT ON TABLE public.seats
    IS 'Seats';

COMMENT ON COLUMN public.seats.aircraft_code
    IS 'Aircraft code, IATA';

COMMENT ON COLUMN public.seats.seat_no
    IS 'Seat number';

COMMENT ON COLUMN public.seats.fare_conditions
    IS 'Travel class';


-- Table: public.ticket_flights

-- DROP TABLE IF EXISTS public.ticket_flights;

CREATE TABLE IF NOT EXISTS public.ticket_flights
(
    ticket_no character(13) COLLATE pg_catalog."default" NOT NULL,
    flight_id integer NOT NULL,
    fare_conditions character varying(10) COLLATE pg_catalog."default" NOT NULL,
    amount numeric(10,2) NOT NULL,
    CONSTRAINT ticket_flights_pkey PRIMARY KEY (ticket_no, flight_id),
    CONSTRAINT ticket_flights_flight_id_fkey FOREIGN KEY (flight_id)
        REFERENCES public.flights (flight_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT ticket_flights_ticket_no_fkey FOREIGN KEY (ticket_no)
        REFERENCES public.tickets (ticket_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT ticket_flights_amount_check CHECK (amount >= 0::numeric),
    CONSTRAINT ticket_flights_fare_conditions_check CHECK (fare_conditions::text = ANY (ARRAY['Economy'::character varying::text, 'Comfort'::character varying::text, 'Business'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.ticket_flights
    OWNER to postgres;

COMMENT ON TABLE public.ticket_flights
    IS 'Flight segment';

COMMENT ON COLUMN public.ticket_flights.ticket_no
    IS 'Ticket number';

COMMENT ON COLUMN public.ticket_flights.flight_id
    IS 'Flight ID';

COMMENT ON COLUMN public.ticket_flights.fare_conditions
    IS 'Travel class';

COMMENT ON COLUMN public.ticket_flights.amount
    IS 'Travel cost';



-- Table: public.tickets

-- DROP TABLE IF EXISTS public.tickets;

CREATE TABLE IF NOT EXISTS public.tickets
(
    ticket_no character(13) COLLATE pg_catalog."default" NOT NULL,
    book_ref character(6) COLLATE pg_catalog."default" NOT NULL,
    passenger_id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    passenger_name text COLLATE pg_catalog."default" NOT NULL,
    contact_data jsonb,
    CONSTRAINT tickets_pkey PRIMARY KEY (ticket_no),
    CONSTRAINT tickets_book_ref_fkey FOREIGN KEY (book_ref)
        REFERENCES public.bookings (book_ref) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tickets
    OWNER to postgres;

COMMENT ON TABLE public.tickets
    IS 'Tickets';

COMMENT ON COLUMN public.tickets.ticket_no
    IS 'Ticket number';

COMMENT ON COLUMN public.tickets.book_ref
    IS 'Booking number';

COMMENT ON COLUMN public.tickets.passenger_id
    IS 'Passenger ID';

COMMENT ON COLUMN public.tickets.passenger_name
    IS 'Passenger name';

COMMENT ON COLUMN public.tickets.contact_data
    IS 'Passenger contact information';