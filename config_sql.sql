CREATE TABLE raq;
CREATE TABLE logistraq;
CREATE TABLE poste_de_garde;
CREATE TABLE coaching_lcm;
CREATE TABLE suivibadge;
CREATE TABLE reporting;
CREATE TABLE poi;
CREATE TABLE grans1_chargement;
CREATE TABLE grans1_haupal;
CREATE TABLE hauteurpalette;
CREATE TABLE lesarcs_haupal;

CREATE USER 'admin_raq'@'localhost' IDENTIFIED BY '82O5g10y0xn5nQ63';
CREATE USER 'admin_logistraq'@'localhost' IDENTIFIED BY 'tW6TMULrj3025I10';
CREATE USER 'admin_pdg'@'localhost' IDENTIFIED BY 'Y695XH5cYCw48Xet';
CREATE USER 'admin_coaching'@'localhost' IDENTIFIED BY '7eFP9ShYpzWFKBE71ZLW';
CREATE USER 'admin_badge'@'localhost' IDENTIFIED BY 'MphW9fLH3eV7RYjW';
CREATE USER 'admin_reporting'@'localhost' IDENTIFIED BY 'FE8D4ljve3AzJ0k2';
CREATE USER 'admin_poi'@'localhost' IDENTIFIED BY 'j3ujmoAOg7PC8Rvv';
CREATE USER 'admin_g1_chgt'@'localhost' IDENTIFIED BY 'a9xH3J12Hn9t4V94';
CREATE USER 'admin_g1_hp'@'localhost' IDENTIFIED BY 'R88aV23B7GpD9rnk';
CREATE USER 'admin_hpalette'@'localhost' IDENTIFIED BY '2ty5J4Z26k9K72v4';
CREATE USER 'admin_arcs_hp'@'localhost' IDENTIFIED BY 'Bf70bFB513eT64O5';

GRANT Insert, Select, Update ON `raq`.* TO `admin_raq`@`localhost`;
GRANT Insert, Select, Update, Delete ON `logistraq`.* TO `admin_logistraq`@`localhost`;
GRANT Insert, Select, Update, Delete ON `poste_de_garde`.* TO `admin_pdg`@`localhost`;
GRANT Insert, Select, Update, Delete ON `admin_coaching`.* TO `coaching_db`@`localhost`;
GRANT Insert, Select, Update ON `suivibadge`.* TO `admin_badge`@`localhost`;
GRANT Insert, Select, Update, Delete ON `reporting`.* TO `admin_reporting`@`localhost`;
GRANT Insert, Select, Update ON `poi`.* TO `admin_poi`@`localhost`;
GRANT Insert, Select, Update ON `grans1_chargement`.* TO `admin_g1_chgt`@`localhost`;
GRANT Insert, Select, Update, Delete ON `grans1_haupal`.* TO `admin_g1_hp`@`localhost`;
GRANT Insert, Select, Update, Delete ON `hauteurpalette`.* TO `admin_hpalette`@`localhost`;
GRANT Insert, Select, Update, Delete ON `lesarcs_haupal`.* TO `admin_arcs_hp`@`localhost`;

FLUSH PRIVILEGES;