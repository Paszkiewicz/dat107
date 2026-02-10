-- ==========================================
-- OPPGAVE A: Opprette tabeller
-- ==========================================

-- Tabeller uten fremmednøkler først
CREATE TABLE IF NOT EXISTS eier (
    id SERIAL PRIMARY KEY,
    navn VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    telefon VARCHAR(20),
    epost VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS bomstasjon (
    id SERIAL PRIMARY KEY,
    navn VARCHAR(255) NOT NULL,
    plassering VARCHAR(255) NOT NULL
);

-- Kjøretøy må tillate NULL i reg-nummer for å støtte uleselige skilt (oppgave d)
CREATE TABLE IF NOT EXISTS kjoretoy (
    id SERIAL PRIMARY KEY,
    registreringsnummer VARCHAR(20) UNIQUE
);

-- Mellomtabeller og tabeller med referanser til slutt
CREATE TABLE IF NOT EXISTS kjoretoy_eier (
    kjoretoyid INTEGER,
    eierid INTEGER,
    FOREIGN KEY (kjoretoyid) REFERENCES kjoretoy(id),
    FOREIGN KEY (eierid) REFERENCES eier(id)
);

CREATE TABLE IF NOT EXISTS bompassering (
    id SERIAL PRIMARY KEY,
    passeringstid TIMESTAMP NOT NULL,
    kjoretoyid INTEGER, -- Kan være NULL for uleselige skilt
    bomstasjonid INTEGER,
    FOREIGN KEY (kjoretoyid) REFERENCES kjoretoy(id),
    FOREIGN KEY (bomstasjonid) REFERENCES bomstasjon(id)
);

-- ==========================================
-- OPPGAVE B: Legge inn testdata
-- ==========================================

INSERT INTO eier (navn, adresse, telefon, epost) VALUES
('Ola Nordmann', 'Osloveien 1', '90000000', 'ola@test.no'),
('Kari Posten', 'Bergenstorget 2', '40000000', 'kari@test.no');

INSERT INTO kjoretoy (registreringsnummer) VALUES
('AA10000'),
('BT20000'),
(NULL); -- Representerer uleselig/ukjent skilt

-- Kobler eiere til biler
INSERT INTO kjoretoy_eier (kjoretoyid, eierid) VALUES 
(1, 1), 
(2, 2);

INSERT INTO bomstasjon (navn, plassering) VALUES
('Hovedveien 1', 'Oslo'),
('Fjordkryssing', 'Bergen');

INSERT INTO bompassering (passeringstid, kjoretoyid, bomstasjonid) VALUES
(CURRENT_TIMESTAMP, 1, 1),    -- Vanlig passering
(CURRENT_TIMESTAMP, NULL, 2); -- Passering uten lest skilt (Oppgave d)

-- ==========================================
-- OPPGAVE C: Dropp telefonnummer
-- ==========================================

ALTER TABLE eier DROP COLUMN telefon;

-- ==========================================
-- OPPGAVE E: List all informasjon (Inkludert uleselige skilt)
-- ==========================================

SELECT p.*, k.registreringsnummer, e.navn, e.epost
FROM bompassering p
LEFT JOIN kjoretoy k ON p.kjoretoyid = k.id
LEFT JOIN kjoretoy_eier ke ON k.id = ke.kjoretoyid
LEFT JOIN eier e ON ke.eierid = e.id;

-- ==========================================
-- OPPGAVE F: List all informasjon (Kun lesbare skilt)
-- ==========================================

SELECT p.*, k.registreringsnummer, e.navn, e.epost
FROM bompassering p
INNER JOIN kjoretoy k ON p.kjoretoyid = k.id
INNER JOIN kjoretoy_eier ke ON k.id = ke.kjoretoyid
INNER JOIN eier e ON ke.eierid = e.id;

-- ==========================================
-- OPPGAVE H: Antall passeringer per regnummer
-- ==========================================

SELECT k.registreringsnummer, COUNT(p.id) AS antall_passeringer
FROM kjoretoy k
JOIN bompassering p ON k.id = p.kjoretoyid
GROUP BY k.registreringsnummer;

-- ==========================================
-- OPPGAVE I: Siste passering for AA10000
-- ==========================================

SELECT MAX(passeringstid) 
FROM bompassering p
JOIN kjoretoy k ON p.kjoretoyid = k.id
WHERE k.registreringsnummer = 'AA10000';

-- ==========================================
-- OPPGAVE J: Antall passeringer uten registreringsnummer
-- ==========================================

SELECT COUNT(*) AS ubetalte_passeringer
FROM bompassering 
WHERE kjoretoyid IS NULL;