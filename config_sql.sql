CREATE TABLE raq;
CREATE TABLE logistraq;
CREATE TABLE poste_de_garde;

GRANT Insert, Select, Update, Delete ON `poste_de_garde`.* TO `admin_pdg`@`localhost`;
GRANT Insert, Select, Update ON `logistraq`.* TO `admin_logistraq`@`localhost`;
GRANT Insert, Select, Update ON `raq`.* TO `admin_raq`@`localhost`;

FLUSH PRIVILEGES;
