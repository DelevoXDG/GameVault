import app


DRIVER_NAME = 'SQL SERVER'
SERVER_NAME = 'DELEVO-PC\SQLEXPRESS'
DATABASE_NAME = 'STEAM'
TABLE_NAME = 'dbo.Games'


def main():
    app.start(DRIVER_NAME, SERVER_NAME, DATABASE_NAME, TABLE_NAME)


if __name__ == '__main__':
    main()
