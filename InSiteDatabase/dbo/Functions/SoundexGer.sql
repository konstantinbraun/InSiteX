CREATE FUNCTION dbo.SoundexGer
(
    @strWord nvarchar(1000)
)
RETURNS nvarchar(1000)
AS
BEGIN

    DECLARE @Word            nvarchar(1000),
            @WordLen         int,
            @Code            nvarchar(1000) = '',
            @PhoneticCode    nvarchar(1000) = '',
            @index           int,
            @RegEx           nvarchar(50),
            @previousCharval nvarchar(1) = '|',
            @Charval         nvarchar(1);

    SET @Word = LOWER(@strWord);
    IF LEN(@Word) < 1
        BEGIN
            RETURN 0
        END;

    -- Umwandlung:
    -- v->f, w->f, j->i, y->i, ph->f, ä->a, ö->o, ü->u, ß->ss, é->e, è->e, à->a, ç->c
    SET @Word = REPLACE(@Word, 'v', 'f')
	SET @Word = REPLACE(@Word, 'w', 'f')
	SET @Word = REPLACE(@Word, 'j', 'i')
	SET @Word = REPLACE(@Word, 'y', 'i')
	SET @Word = REPLACE(@Word, 'ä', 'a')
	SET @Word = REPLACE(@Word, 'ö', 'o')
	SET @Word = REPLACE(@Word, 'ü', 'u')
	SET @Word = REPLACE(@Word, 'é', 'e')
	SET @Word = REPLACE(@Word, 'è', 'e')
	SET @Word = REPLACE(@Word, 'ê', 'e')
	SET @Word = REPLACE(@Word, 'à', 'a')
	SET @Word = REPLACE(@Word, 'á', 'a')
	SET @Word = REPLACE(@Word, 'ç', 'c')
	SET @Word = REPLACE(@Word, 'ph', 'f')
	SET @Word = REPLACE(@Word, 'ß', 'ss');

    -- Zahlen und Sonderzeichen entfernen
    SET @RegEx = '%[^a-z]%';
    WHILE PATINDEX(@RegEx, @Word) > 0
    SET @Word = STUFF(@Word, PATINDEX(@RegEx, @Word), 1, '');

    -- Bei Strings der Länge 1 wird ein Leerzeichen angehängt, um die Anlautprüfung auf den zweiten Buchstaben zu ermöglichen.
    SET @WordLen = LEN(@Word);
    IF @WordLen = 1
        BEGIN
            SET @Word += ' '
        END;

    -- Sonderfälle am Wortanfang
    IF SUBSTRING(@Word, 1, 1) = 'c'
        BEGIN

            -- vor a,h,k,l,o,q,r,u,x
            SET @Code = CASE
                            WHEN SUBSTRING(@Word, 2, 1) IN('a', 'h', 'k', 'l', 'o', 'q', 'r', 'u', 'x')
                            THEN '4'
                            ELSE '8'
                        END;
            SET @index = 2;
        END;
    ELSE
        BEGIN
            SET @index = 1;
        END;

    -- Codierung    
    WHILE @index <= @WordLen
        BEGIN
            SET @Code = CASE
                            WHEN SUBSTRING(@Word, @index, 1) IN('a', 'e', 'i', 'o', 'u')
                            THEN @Code + '0'
                            WHEN SUBSTRING(@Word, @index, 1) = 'b'
                            THEN @Code + '1'
                            WHEN SUBSTRING(@Word, @index, 1) = 'p'
                            THEN IIF(@index < @WordLen, IIF(SUBSTRING(@Word, @index + 1, 1) = 'h', @Code + '3', @Code + '1'), @Code + '1')
                            WHEN SUBSTRING(@Word, @index, 1) IN('d', 't')
                            THEN IIF(@index < @WordLen, IIF(SUBSTRING(@Word, @index + 1, 1) IN('c', 's', 'z'), @Code + '8', @Code + '2'), @Code + '2')
                            WHEN SUBSTRING(@Word, @index, 1) = 'f'
                            THEN @Code + '3'
                            WHEN SUBSTRING(@Word, @index, 1) IN('g', 'k', 'q')
                            THEN @Code + '4'
                            WHEN SUBSTRING(@Word, @index, 1) = 'c'
                            THEN IIF(@index < @WordLen, IIF(SUBSTRING(@Word, @index + 1, 1) IN('a', 'h', 'k', 'o', 'q', 'u', 'x'), IIF(SUBSTRING(@Word, @index - 1, 1) = 's'
                                                                                                                                    OR SUBSTRING(@Word, @index - 1, 1) = 'z', @Code + '8', @Code + '4'), @Code + '8'), @Code + '8')
                            WHEN SUBSTRING(@Word, @index, 1) = 'x'
                            THEN IIF(@index > 1, IIF(SUBSTRING(@Word, @index - 1, 1) IN('c', 'k', 'x'), @Code + '8', @Code + '48'), @Code + '48')
                            WHEN SUBSTRING(@Word, @index, 1) = 'l'
                            THEN @Code + '5'
                            WHEN SUBSTRING(@Word, @index, 1) = 'm'
                                OR SUBSTRING(@Word, @index, 1) = 'n'
                            THEN @Code + '6'
                            WHEN SUBSTRING(@Word, @index, 1) = 'r'
                            THEN @Code + '7'
                            WHEN SUBSTRING(@Word, @index, 1) = 's'
                                OR SUBSTRING(@Word, @index, 1) = 'z'
                            THEN @Code + '8'
                            ELSE @Code
                        END;
            SET @index+=1;
        END;

    -- die mehrfachen Codes entfernen und erst dann die „0“ eliminieren
    -- Am Wortanfang bleiben „0“-Codes erhalten
    SET @index = 0;
    WHILE @index < LEN(@code)
        BEGIN
            SET @charval = SUBSTRING(@code, @index + 1, 1);
            IF @charval <> @previousCharval
                BEGIN
                    IF @charval <> '0'
                    OR @index = 0
                        BEGIN
                            SET @PhoneticCode += @charval;
                        END;
                END;
            SET @previousCharval = @charval;
            SET @index += 1;
        END;

    RETURN @PhoneticCode;

END;
