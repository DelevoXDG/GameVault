import app

DRIVER_NAME = 'SQL SERVER'
SERVER_NAME = 'DELEVO-PC\SQLEXPRESS'
DATABASE_NAME = 'STEAM'


def main():
    app.start(DRIVER_NAME, SERVER_NAME, DATABASE_NAME, 'Games')


if __name__ == '__main__':
    main()
