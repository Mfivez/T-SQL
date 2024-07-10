/** Create DB **/
CREATE DATABASE t_sql_module1
GO

/** USE DB **/
USE t_sql_module1
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.1 
Se connecter à SQL Server et créer une nouvelle requête.
Créer une table ayant une colonne de type INTEGER, auto-incrémentée.
Où cette table s’est-elle créée ? Comment pouvez-vous la visualiser ?
**/

CREATE TABLE my_table (
	column1 INT IDENTITY (1,1)
	)
GO

-- Le mot-clé IDENTITY est utilisé pour créer une colonne avec auto-incrémentation. 
-- Il a deux paramètres à spécifier avec lui:
-- (1,1) :
--    - Le premier 1 est la valeur initiale pour la première ligne.
--    - Le deuxième est le pas, c'est-à-dire l'incrément ajouté pour chaque nouvelle ligne.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.2 
Créer une nouvelle base de données.
Créer une table contenant 2 colonnes dont une possède la contrainte UNIQUE, dans cette
base de données. 
S’assurer que la table apparaît bien dans cette nouvelle base de données et pas dans la 
base de données « MASTER » (via la commande USE db_name)
**/

-- CREATE DATABASE t_sql_module1
-- USE t_sql_module1

CREATE TABLE my_table2 (
	column1 INT, -- column1 : Un entier (INT).
	column2 VARCHAR(50), -- column2 : Une chaîne de caractères avec une longueur maximale de 50 caractères (VARCHAR(50)).
	CONSTRAINT UK_column2 UNIQUE (column2)
)
GO

-- La contrainte UNIQUE sur column2 garantit que chaque valeur dans column2 est unique.
-- UK_column2 est le nom de la contrainte.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.3
A l’aide de l’instruction « PRINT », afficher le message « Bonjour, et bienvenue dans le
cours de Transact SQL ! »
**/

PRINT 'Bonjour, et bienvenue dans le cours de Transact SQL !'
GO

-- La commande PRINT affiche un message texte dans la fenêtre de messages.
-- Cette commande est souvent utilisée pour déboguer et informer l'utilisateur de l'état ou de l'avancement du script.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.4
Afficher le même message qu’à l’exercice 1.3. mais en utilisant cette fois une table
temporaire
**/


-- Sélectionne le message 'Bonjour, et bienvenue dans le cours de Transact SQL !'
-- et le stocke dans une table temporaire nommée #my_temp_table
SELECT 'Bonjour, et bienvenue dans le cours de Transact SQL !' 
	AS 'Message'
	INTO #my_temp_table

-- Affiche le contenu de la table temporaire #my_temp_table
SELECT * FROM #my_temp_table
GO

-- La commande PRINT ne peut pas être utilisée pour afficher le contenu d'une table temporaire.
-- Il est donc incorrect de tenter d'utiliser PRINT pour afficher #my_temp_table.

-- Le mot-clé AS est utilisé pour donner un alias à la colonne (ici 'MESSAGE').
-- Cela permet de nommer la colonne résultante dans la table temporaire.


-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.5  **/
/** Insérer une ligne de valeurs dans la table créée au point 1.2. **/
INSERT INTO my_table2 VALUES(1, 'Bonjour')

/** Insérer une seconde ligne identique. Un message d’erreur doit apparaître. A quelle ligne se situe le message ? **/
INSERT INTO my_table2 VALUES(1, 'Bonjour')
GO

-- Dans la sortie console, on peut retrouver l'information 'Line x' qui représente la ligne ou l'erreur s'est produite.

/** Comment trouver cette ligne instantanément ?  **/
-- Il suffit de faire un double clique gauche sur le message d'erreur dans la console ! 


/** Comprenez-vous ce message ? Comment pouvez-vous faire pour le comprendre si l’anglais n’est pas votre fort ?  **/
-- L'erreur est dû au fait qu'on ne respecte pas la contrainte d'unicité. 
-- Si on ne la comprend pas, il suffit de copier coller le message dans google et de faire une petite recherche .

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.6.1
A l’aide d’une instruction de simple « SELECT », afficher les données contenues dans la
table du point 1.2.
**/

SELECT * FROM my_table2



/**    1.6.2
Stocker à présent la requête SQL dans une variable que vous aurez préalablement déclarée
pour afficher son contenu à l’aide de la commande « EXEC ».
Référez-vous aux informations du cours théorique pour la déclaration de votre variable
que nous n’avons pas encore vu à ce stade.
**/

-- Déclare une variable @SQL avec son type
DECLARE @SQL VARCHAR(50)

-- Assigne une valeur à la variable @SQL
SET @SQL = 'SELECT * FROM my_table2';

-- Exécute la commande SQL stockée dans la variable @SQL
EXEC (@SQL)

-- Vous avez peut-être pu remarquer au cours de vos tests que si @SQL n'était pas spécifié entre parenthèses, une erreur se produisait.
-- Celle-ci vous prévenait du fait que @SQL n'était pas une procédure stockée existante.

-- C'est tout à fait normal !

-- Ce que l'on fait ici via les parenthèses dans la commande EXEC, 
-- s'appelle 'commande dynamique', cela permet d'exécuter une requête SQL que
-- l'on aurait soit stocké dans une variable, soit pas stocké du tout. Par exemple :
EXEC ('SELECT * FROM my_table2')

GO
-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------