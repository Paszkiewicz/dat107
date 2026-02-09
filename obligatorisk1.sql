CREATE TABLE IF NOT EXISTS kjoretoy (
    id SERIAL PRIMARY KEY,
    registreringsnummer VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS kjoretoy_eier (
    kjoretoyid INTEGER,
    eierid INTEGER,
    FOREIGN KEY (kjoretoyid) REFERENCES kjoretoy(id),
    FOREIGN KEY (eierid) REFERENCES eier(id)
);

CREATE TABLE IF NOT EXISTS eier (
    id SERIAL PRIMARY KEY,
    navn VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    telefon VARCHAR(20),
    epost VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS bompassering (
    id SERIAL PRIMARY KEY,
    passeringstid TIMESTAMP NOT NULL

    kjoretoyid INTEGER,
    bomstasjonid INTEGER,
    FOREIGN KEY (kjoretoyid) REFERENCES kjoretoy(id),
    FOREIGN KEY (bomstasjonid) REFERENCES bomstasjon(id),
);

CREATE TABLE IF NOT EXISTS bomstasjon (
    id SERIAL PRIMARY KEY,
    navn VARCHAR(255) NOT NULL,
    plassering VARCHAR(255) NOT NULL
);