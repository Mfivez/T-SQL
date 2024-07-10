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
Se connecter � SQL Server et cr�er une nouvelle requ�te.
Cr�er une table ayant une colonne de type INTEGER, auto-incr�ment�e.
O� cette table s�est-elle cr��e ? Comment pouvez-vous la visualiser ?
**/

CREATE TABLE my_table (
	column1 INT IDENTITY (1,1)
	)
GO

-- Le mot-cl� IDENTITY est utilis� pour cr�er une colonne avec auto-incr�mentation. 
-- Il a deux param�tres � sp�cifier avec lui:
-- (1,1) :
--    - Le premier 1 est la valeur initiale pour la premi�re ligne.
--    - Le deuxi�me est le pas, c'est-�-dire l'incr�ment ajout� pour chaque nouvelle ligne.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.2 
Cr�er une nouvelle base de donn�es.
Cr�er une table contenant 2 colonnes dont une poss�de la contrainte UNIQUE, dans cette
base de donn�es. 
S�assurer que la table appara�t bien dans cette nouvelle base de donn�es et pas dans la 
base de donn�es � MASTER � (via la commande USE db_name)
**/

-- CREATE DATABASE t_sql_module1
-- USE t_sql_module1

CREATE TABLE my_table2 (
	column1 INT, -- column1 : Un entier (INT).
	column2 VARCHAR(50), -- column2 : Une cha�ne de caract�res avec une longueur maximale de 50 caract�res (VARCHAR(50)).
	CONSTRAINT UK_column2 UNIQUE (column2)
)
GO

-- La contrainte UNIQUE sur column2 garantit que chaque valeur dans column2 est unique.
-- UK_column2 est le nom de la contrainte.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.3
A l�aide de l�instruction � PRINT �, afficher le message � Bonjour, et bienvenue dans le
cours de Transact SQL ! �
**/

PRINT 'Bonjour, et bienvenue dans le cours de Transact SQL !'
GO

-- La commande PRINT affiche un message texte dans la fen�tre de messages.
-- Cette commande est souvent utilis�e pour d�boguer et informer l'utilisateur de l'�tat ou de l'avancement du script.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.4
Afficher le m�me message qu�� l�exercice 1.3. mais en utilisant cette fois une table
temporaire
**/


-- S�lectionne le message 'Bonjour, et bienvenue dans le cours de Transact SQL !'
-- et le stocke dans une table temporaire nomm�e #my_temp_table
SELECT 'Bonjour, et bienvenue dans le cours de Transact SQL !' 
	AS 'Message'
	INTO #my_temp_table

-- Affiche le contenu de la table temporaire #my_temp_table
SELECT * FROM #my_temp_table
GO

-- La commande PRINT ne peut pas �tre utilis�e pour afficher le contenu d'une table temporaire.
-- Il est donc incorrect de tenter d'utiliser PRINT pour afficher #my_temp_table.

-- Le mot-cl� AS est utilis� pour donner un alias � la colonne (ici 'MESSAGE').
-- Cela permet de nommer la colonne r�sultante dans la table temporaire.


-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.5  **/
/** Ins�rer une ligne de valeurs dans la table cr��e au point 1.2. **/
INSERT INTO my_table2 VALUES(1, 'Bonjour')

/** Ins�rer une seconde ligne identique. Un message d�erreur doit appara�tre. A quelle ligne se situe le message ? **/
INSERT INTO my_table2 VALUES(1, 'Bonjour')
GO

-- Dans la sortie console, on peut retrouver l'information 'Line x' qui repr�sente la ligne ou l'erreur s'est produite.

/** Comment trouver cette ligne instantan�ment ?  **/
-- Il suffit de faire un double clique gauche sur le message d'erreur dans la console ! 


/** Comprenez-vous ce message ? Comment pouvez-vous faire pour le comprendre si l�anglais n�est pas votre fort ?  **/
-- L'erreur est d� au fait qu'on ne respecte pas la contrainte d'unicit�. 
-- Si on ne la comprend pas, il suffit de copier coller le message dans google et de faire une petite recherche .

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    1.6.1
A l�aide d�une instruction de simple � SELECT �, afficher les donn�es contenues dans la
table du point 1.2.
**/

SELECT * FROM my_table2



/**    1.6.2
Stocker � pr�sent la requ�te SQL dans une variable que vous aurez pr�alablement d�clar�e
pour afficher son contenu � l�aide de la commande � EXEC �.
R�f�rez-vous aux informations du cours th�orique pour la d�claration de votre variable
que nous n�avons pas encore vu � ce stade.
**/

-- D�clare une variable @SQL avec son type
DECLARE @SQL VARCHAR(50)

-- Assigne une valeur � la variable @SQL
SET @SQL = 'SELECT * FROM my_table2';

-- Ex�cute la commande SQL stock�e dans la variable @SQL
EXEC (@SQL)

-- Vous avez peut-�tre pu remarquer au cours de vos tests que si @SQL n'�tait pas sp�cifi� entre parenth�ses, une erreur se produisait.
-- Celle-ci vous pr�venait du fait que @SQL n'�tait pas une proc�dure stock�e existante.

-- C'est tout � fait normal !

-- Ce que l'on fait ici via les parenth�ses dans la commande EXEC, 
-- s'appelle 'commande dynamique', cela permet d'ex�cuter une requ�te SQL que
-- l'on aurait soit stock� dans une variable, soit pas stock� du tout. Par exemple :
EXEC ('SELECT * FROM my_table2')

GO
-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------